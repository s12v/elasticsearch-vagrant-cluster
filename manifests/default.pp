exec { 'apt-get update':
  path => '/usr/bin',
}

class { 'elasticsearch':
  version => '1.3.4',
  java_install => true,
  manage_repo  => true,
  repo_version => '1.3',
  config => {
    'cluster.name' => 'esearch-testcluster',
  },
  require => Exec['apt-get update'],
}

elasticsearch::instance { 'esearch-testcluster':
  config => {
    'network.host' => "${guest_ip}",
    'index.number_of_shards' => "${number_of_shards}",
    'index.number_of_replicas' => "${number_of_replicas}",
    'marvel.agent.enabled' => false,
    'http.cors.enabled' => true,
    'http.cors.allow-origin' => 'null',
  },
  init_defaults => {
    'ES_HEAP_SIZE' => '384m',
  }
}

elasticsearch::plugin{ 'lmenezes/elasticsearch-kopf':
  module_dir => 'kopf',
  instances  => 'esearch-testcluster'
}

elasticsearch::plugin{ 'elasticsearch/marvel/latest':
  module_dir => 'marvel',
  instances  => 'esearch-testcluster'
}
