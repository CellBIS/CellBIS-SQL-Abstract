#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use CellBIS::SQL::Abstract;

my $sql_abstract = CellBIS::SQL::Abstract->new();
my $select1 = $sql_abstract->select('table_test', []);
my $select2 = $sql_abstract->select('table_test', [], {
  'orderby' => 'id_mhs_kelas',
  'order' => 'asc',
  'limit' => '5'
});
ok($select1 eq 'SELECT * FROM table_test', "[$select1] is true");
ok($select2 eq 'SELECT * FROM table_test ORDER BY id_mhs_kelas ASC LIMIT 5', "[$select2] is true");

done_testing();
