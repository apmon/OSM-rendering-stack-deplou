class osmtileserver {
  
  package {
    [ "libapache2-mod-tile", "renderd", "openstreetmap-mapnik-stylesheet-data", "osmosis" ]:
      ensure => latest,
  }


  service {
    "apache2":
      ensure => running,
      enable => "true",
      require => package["libapache2-mod-tile"],
      hasrestart => "true",
  }

  service {
    "renderd":
      ensure => running,
      enable => "true",
      require => package["renderd"],
      hasrestart => "true",
  }

  cron { "osm_db_update":
    ensure  => present,
    command => "/tmp/home/osm/tools/load-next > /dev/null 2>&1",
    user => "osm",
    minute => [5, 20, 35, 50],
    require => File["/tmp/home/osm/tools/load-next"],
  }
  
  file {
    "/etc/apache2/mods-enabled/tile.load":
      notify  => Service["apache2"],
      ensure => 'link',
      target => '/etc/apache2/mods-available/tile.load',
      require => Package["libapache2-mod-tile"],
  }

  file {
    "/etc/apache2/sites-available/tileserver":
      notify  => Service["apache2"],
      owner => root,
      group => root,
      mode => 0744,
      source => "puppet:///files/openstreetmap/tileserver_site",
      require => Package["libapache2-mod-tile"],
  }

  file {
    "/etc/apache2/sites-enabled/tileserver_site":
      notify  => Service["apache2"],
      ensure => 'link',
      target => '/etc/apache2/sites-available/tileserver_site',
      require => Package["libapache2-mod-tile"],
  }

  file {
    "/etc/apache2/sites-enabled/000-default":
      notify  => Service["apache2"],
      ensure => 'absent',
      require => Package["libapache2-mod-tile"],
  }

  file {
    "/etc/renderd.conf":
      notify => Service["apache2", "renderd"],
      owner => root,
      group => root,
      mode => 0644,
      source => "puppet:///files/openstreetmap/renderd.conf",
      require => Package["renderd"],
  }

  file {
    "/etc/mapnik-osm-data/inc/datasource-settings.xml.inc":
      notify => Service["apache2", "renderd"],
      owner => root,
      group => root,
      mode => 0644,
      source => "puppet:///files/openstreetmap/datasource-settings.xml.inc",
      require => Package["openstreetmap-mapnik-stylesheet-data"],
  }

  file { "/var/lib/mod_tile/.osmosis/":
    ensure => directory, # so make this a directory
    recurse => true, # enable recursive directory management
    owner => "osm",
    group => "osm",
    mode => 0644, # this mode will also apply to files from the source directory
    require => Package["osmosis"],
  }

  file {
    "/var/lib/mod_tile/.osmosis/configuration.txt":
      owner => osm,
      group => osm,
      mode => 0644,
      source => "puppet:///files/openstreetmap/osmosis.configuration.txt",
      require => Package["osmosis"],
  }

  file { "/tmp/home/osm/tools/":
    ensure => directory, # so make this a directory
    recurse => true, # enable recursive directory management
    owner => "osm",
    group => "osm",
    mode => 0644, # this mode will also apply to files from the source directory
    require => User["osm"],
  }
  

  file { "/tmp/home/osm/tools/logs":
    ensure => directory, # so make this a directory
    recurse => true, # enable recursive directory management
    owner => "osm",
    group => "osm",
    mode => 0644, # this mode will also apply to files from the source directory
    require => User["osm"],
  }

  file { "/tmp/home/osm/tools/import-planet":
    owner => osm,
    group => osm,
    mode => 0744,
    source => "puppet:///files/openstreetmap/import-planet",
    require => User["osm"],
  
  }

  file { "/tmp/home/osm/tools/load-next":
    owner => osm,
    group => osm,
    mode => 0744,
    source => "puppet:///files/openstreetmap/load-next",
    require => User["osm"],
  }
  
  
  
    
}


