class postgresql {

    package {
      "postgresql":
        ensure => latest;
      "postgresql-contrib":
        ensure => latest;
      "postgis":
        ensure => latest;
      "postgresql-9.1-postgis":
        ensure => latest;
      
    }

    service { "postgresql":
        name => postgresql,
        ensure => running,
        enable => true,
        subscribe => File['/etc/postgresql/9.1/main/postgresql.conf', '/etc/postgresql/9.1/main/pg_hba.conf'],
    }

    file {"/etc/postgresql/9.1/main/postgresql.conf":
          owner   => postgres,
          group   => postgres,
          notify  => Service["postgresql"],
    }

    file {"/etc/postgresql/9.1/main/pg_hba.conf":
          owner   => postgres,
          group   => postgres,
          notify  => Service["postgresql"],
    }

    user { "postgres":
      ensure => present
    }

    user { "osm":
      ensure => present,
      shell => "/bin/bash",
    }

    postgres::createuser { "osm": }
    postgres::createuser { "www-data": }
    postgres::createdb { "osm_mapnik":
      sqlowner => "osm",
    }
    postgres::sqlfileexecSU { "postgis":
      database => "osm_mapnik",
      sql => "/usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql",
      sqlcheck => "SELECT PostGIS_full_version();",
    }
    postgres::sqlfileexecSU { "postgis-ref-sys":
      database => "osm_mapnik",
      sql => "/usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql",
      sqlcheck => "SELECT srid FROM spatial_ref_sys WHERE srid='900913';",
    }
    postgres::sqlexecSU { "permissions":
      database => "osm_mapnik",
      sql => "ALTER TABLE geometry_columns OWNER TO osm; ALTER TABLE spatial_ref_sys OWNER TO osm; GRANT SELECT ON geometry_columns TO PUBLIC; GRANT SELECT ON spatial_ref_sys TO PUBLIC;",
      sqlcheck => "",
    }
    postgres::sqlexecSU { "hstore":
      database => "osm_mapnik",
      sql => "CREATE EXTENSION hstore;",
      sqlcheck => "SELECT extname FROM pg_extension WHERE extname='hstore';",
    }

    #sysctl::conf {
    #  "kernel.shmmax": value =>  4294967296; # in bytes
    #}
}

# Base SQL exec
define postgres::sqlexecSU($database, $sql, $sqlcheck) {
    exec{ "/bin/su postgres -c \"echo \\\"$sql\\\" | psql $database\"":
        timeout     => 600,
        unless      => "/bin/su postgres -c \"echo \\\"$sqlcheck\\\" | psql $database\" | grep \"(1 row)\"",
        require     =>  [User['postgres'],Service["postgresql"],Package["postgresql-9.1-postgis"]],
    }
}

# Base SQL file exec
define postgres::sqlfileexecSU($database, $sql, $sqlcheck) {
    exec{ "/bin/su postgres -c \" psql -d $database -f $sql\"":
        timeout     => 600,
        unless      => "/bin/su postgres -c \"echo \\\"$sqlcheck\\\" | psql $database\" | grep \"(1 row)\"",
        require     =>  [User['postgres'],Service["postgresql"],Package["postgresql-9.1-postgis"]],
    }
}

#Create a Postgres user role
define postgres::createuser() {
    postgres::sqlexecSU{ $name:
        database => "postgres",
        sql      => "CREATE USER \\\\\\\"$name\\\\\\\";",
        sqlcheck => "SELECT usename FROM pg_catalog.pg_user WHERE usename = '$name';",
    }
}

# Create a Postgres db
define postgres::createdb($sqlowner) {
    postgres::sqlexecSU{ $name:
        database => "postgres",
        sql      => "CREATE DATABASE $name WITH OWNER = \"$sqlowner\" ENCODING = 'UTF8' TEMPLATE=template0;",
        sqlcheck => "SELECT datname FROM pg_database WHERE datname = '$name'",
    }
}


