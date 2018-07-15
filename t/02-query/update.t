#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use FindBin;
use lib "$FindBin::Bin/../../lib";

use CellBIS::SQL::Abstract;

my $sql_abstract = CellBIS::SQL::Abstract->new();
my $to_compare = '';

$to_compare =
  'UPDATE table_test SET clause_col1=?, col2=?, col3=? '.
  'WHERE clause_col1 = ? AND clause_col2 = ? OR clause_col3 = ? '.
  'ORDER BY col1 ASC LIMIT 1';
my $update = $sql_abstract->update(
  'table_test',
  [ 'clause_col1', 'col2', 'col3' ],
  [ 'val1', 'val2', 'val3', 'clause_val1', 'clause_val2', 'clause_val3' ],
  {
    'where'   => 'clause_col1 = ? AND clause_col2 = ? OR clause_col3 = ?',
    'orderby' => 'col1',
    'order'   => 'asc', # asc || desc
    'limit'   => '1'
  });
is($sql_abstract->to_one_liner($update), $to_compare, "SQL Query : \n$update");

$to_compare =
  'UPDATE table_test SET clause_col1=?, col2=?, col3=? '.
  'WHERE clause_col1 = ? AND clause_col2 = ? OR clause_col3 = ? '.
  'ORDER BY col1 ASC';
$update = $sql_abstract->update(
  'table_test',
  [ 'clause_col1', 'col2', 'col3' ],
  [ 'val1', 'val2', 'val3', 'clause_val1', 'clause_val2', 'clause_val3' ],
  {
    'where'   => 'clause_col1 = ? AND clause_col2 = ? OR clause_col3 = ?',
    'orderby' => 'col1',
    'order'   => 'asc', # asc || desc
  });
is($sql_abstract->to_one_liner($update), $to_compare, "SQL Query : \n$update");

$to_compare =
  'UPDATE table_test SET clause_col1=?, col2=?, col3=? '.
  'WHERE clause_col1 = ? AND clause_col2 = ? OR clause_col3 = ?';
$update = $sql_abstract->update(
  'table_test',
  [ 'clause_col1', 'col2', 'col3' ],
  [ 'val1', 'val2', 'val3', 'clause_val1', 'clause_val2', 'clause_val3' ],
  {
    'where'   => 'clause_col1 = ? AND clause_col2 = ? OR clause_col3 = ?',
  });
is($sql_abstract->to_one_liner($update), $to_compare, "SQL Query : \n$update");

done_testing();
