#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/lib";

use CellBIS::SQL::Abstract;

my $sql_abstract = CellBIS::SQL::Abstract->new();

my $select1 = $sql_abstract->select('table_test', []);
ok($select1 eq 'SELECT * FROM table_test', "SQL Query [$select1] is true");

my $select2 = $sql_abstract->select('table_test', [], {
  'orderby' => 'id_test',
  'order' => 'asc',
  'limit' => '5'
});
ok($select2 eq 'SELECT * FROM table_test ORDER BY id_test ASC LIMIT 5', "SQL Query [$select2] is true");

done_testing();
