package TestDB;

use strict;
use warnings;
use base 'DBIx::Class::Schema';

sub init_schema {
  my $self = shift;

  my $dsn = 'dbi:SQLite:dbname=:memory:';
  my $schema = $self->connect($dsn);
  $schema->deploy;

  return $schema;

}

__PACKAGE__->load_classes;

1;
