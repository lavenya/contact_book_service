yaml_config = YAML.load_file('config/elasticsearch.yml').symbolize_keys

config = {
  host: yaml_config[:host],
  transport_options: {
    request: { timeout: yaml_config[:timeout] }
  }
}

Elasticsearch::Model.client = Elasticsearch::Client.new(config)
