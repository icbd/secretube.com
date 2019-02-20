module DockerEngine
  def healthy?
    response = version
    response.success?
  end

  # Create a container and start it
  def run_container(port:, password:, name:)
    response_of_create = create_container(port: port, password: password, name: name)
    return unless response_of_create.success?

    begin
      container_id = JSON.parse(response_of_create.body).fetch('Id')
    rescue JSON::ParserError
      return false
    rescue KeyError
      return false
    end
    start_container(container_id: container_id)
  end

  # https://docs.docker.com/engine/api/v1.39/#operation/ContainerCreate
  # docker run -e PASSWORD=%{YourPassword} -e METHOD=aes-256-cfb \
  #             -p %{HostPort}:8388/tcp -p %{HostPort}:8388/udp \
  #             --rm -m 20M --name first-test \
  #             -d shadowsocks/shadowsocks-libev
  #
  # MARK: 加密算法推荐换成 `aes-256-cfb`, 默认的 `aes-256-gcm` 很多系统不支持
  # MARK: `--name` 参数应该放在 `Query Parameters` 上
  def create_container(port:, password:, name:)
    request_params = {
      Image: 'shadowsocks/shadowsocks-libev',
      Env: ["PASSWORD=#{password}", 'METHOD=aes-256-cfb'],
      ExposedPorts: { '8388/tcp': {},
                      '8388/udp': {} },
      HostConfig: {
        Memory: 30_000_000,
        AutoRemove: true,
        PortBindings: { '8388/tcp': [{ HostPort: port.to_s }],
                        '8388/udp': [{ HostPort: port.to_s }] }
      }
    }
    conn.post("/containers/create?name=#{name}") do |req|
      req.body = request_params.to_json
    end
  end

  # Choose container_id or container_name
  def start_container(container_id: nil, container_name: nil)
    return if container_id.nil? && container_name.nil?

    id = container_id.nil? ? container_name : container_id
    conn.post("/containers/#{id}/start")
  end

  # Choose container_id or container_name
  def stop_container(container_id: nil, container_name: nil)
    return if container_id.nil? && container_name.nil?

    id = container_id.nil? ? container_name : container_id
    conn.post("/containers/#{id}/stop")
  end

  def version
    conn.get('/version')
  end

  private

  def conn
    @conn ||= Faraday::Connection.new(url: "http://#{ipv4}:#{docker_daemon_port}") do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
      faraday.request :url_encoded
      faraday.response :logger, Rails.logger, bodies: true
      faraday.adapter Faraday.default_adapter
    end
  end
end
