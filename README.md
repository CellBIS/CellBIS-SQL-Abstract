# CellBIS::SQL::Abstract - SQL Query Generator

The purpose of this module is to generate SQL Query. General queries has covered
`insert`, `delete`, `update`, `select`, and **select** with **join** - (`select_join`).
And the additional query has covered to create table

You can you this module for [Mojo::mysql](https://metacpan.org/pod/Mojo::mysql) 
or [DBI](https://metacpan.org/pod/DBI).

## Synopsis Module :
```perl5
use CellBIS::SQL::Abstract
my $sql_abstract = CellBIS::SQL::Abstract->new;

# Create Table
my $table_name = 'my_table_name'; # Table name.
my $col_list = []; # List of column table
my $col_attr = {}; # Attribute column table.

# insert
my $table_name = 'my_table_name'; # Table name.
my $column = []; # List of column in the table (array ref data type)
my $value = []; # Value of column (array ref data type)
$sql_abstract->insert($table_name, $column, $value);

# update
my $table_name = 'my_table_name'; # Table name.
my $column = []; # List of column in the table (array ref data type)
my $value = []; # Value of column (array ref data type)
my $clause = {}; # Clause of SQL Query, like where, order by, group by, and etc.
$sql_abstract->update($table_name, $column, $value, $clause);

# delete
my $table_name = 'my_table_name'; # Table name.
my $clause = {}; # Clause of SQL Query, like where, order by, group by, and etc.
$sql_abstract->delete($table_name, $clause);

# select
my $table_name = 'my_table_name'; # Table name.
my $column = []; # List of column in the table (array ref data type)
my $clause = {}; # Clause of SQL Query, like where, order by, group by, and etc.
$sql_abstract->select($table_name, $column, $clause);

# select_join
my $table_list = []; # List of table. (array ref data type)
my $column = []; # List of column to select. (array ref data type)
my $clause = {}; # Clause of SQL Query.
$sql_abstract->select($table_list, $column, $clause);
```

## Methods

CellBIS::SQL::Abstract inherit from L<Mojo::Base>.
Methods `insert`, `update`, `select`, and `select_join` can use **prepare statement** or **not**.

The following are the methods available from this module:

### create_table :
```perl5
use CellBIS::SQL::Abstract
my $sql_abstract = CellBIS::SQL::Abstract->new;

my $table_name = 'my_users';
my $col_list = [ 'id', 'first_name', 'last_name', 'other_col_name' ];
my $col_attr = {
  'id'             => {
    type          => {
      name => 'int',
      size => 11
    },
    is_primarykey => 1,
    is_autoincre  => 1,
  },
  'first_name'     => {
    type    => {
      name => 'varchar',
      size => 50,
    },
    is_null => 0,
  },
  'last_name'      => {
    type    => {
      name => 'varchar',
      size => 50,
    },
    is_null => 0,
  },
  'other_col_name' => {
    type    => {
      name => 'varchar',
      size => 60,
    },
    is_null => 0,
  }
};
my $create_table = $sql_abstract->create_table($table_name, $col_list, $col_attr);
```
This equivalent with :
```mysql
CREATE TABLE IF NOT EXISTS users(
    id INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    other_col_name VARCHAR(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8
```

### create_table with Foreign key 
```perl5
use CellBIS::SQL::Abstract
my $sql_abstract = CellBIS::SQL::Abstract->new;

my $table_name = 'my_companies';
my $col_list = [
  'id_company',
  'id_company_users',
  'company_name',
];
my $col_attr = {
  'id_company'       => {
    type          => {
      name => 'int',
      size => '11'
    },
    is_primarykey => 1,
    is_autoincre  => 1,
  },
  'id_company_users' => {
    type    => {
      name => 'int',
      size => '11',
    },
    is_null => 0,
  },
  'company_name'     => {
    type    => {
      name => 'varchar',
      size => '200',
    },
    is_null => 0,
  }
};
my $table_attr = {
  fk      => {
    name         => 'user_companies_fk',
    col_name     => 'id_company_users',
    table_target => 'users',
    col_target   => 'id',
    attr         => {
      onupdate => 'cascade',
      ondelete => 'cascade'
    }
  },
  charset => 'utf8',
  engine  => 'innodb',
};
my $create_table = $sql_abstract->create_table($table_name, $col_list, $col_attr, $table_attr);
```
This equivalent with :
```mysql
CREATE TABLE IF NOT EXISTS company(
    id_company INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_company_users INT(11) NOT NULL,
    company_name VARCHAR(200) NOT NULL,
    KEY user_company_fk (id_company_users),
    CONSTRAINT user_company_fk FOREIGN KEY (id_company_users) REFERENCES users (id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

### insert
```perl5
use CellBIS::SQL::Abstract
my $sql_abstract = CellBIS::SQL::Abstract->new;

my $table_name = 'my_users';
my $column = [
  'first_name',
  'last_name'
];
my $value = [
  'my_name',
  'my_last_name'
];

# If no Prepare Statement
my $insert_no_pre_st = $sql_abstract->insert($table_name, $column, $value);

# IF Prepare Statement
my $insert = $sql_abstract->insert($table_name, $column, $value, 'pre-st');
```
SQL equivalent :
```mysql
# No Prepare Statement :
INSERT INTO my_users(first_name, last_name) VALUES('my_name', 'my_last_name');

# Prepare Statement :
INSERT INTO my_users(first_name, last_name) VALUES(?, ?);
```

### update
```perl5
use CellBIS::SQL::Abstract
my $sql_abstract = CellBIS::SQL::Abstract->new;

my $table_name = 'my_users'; # Table name.
my $column = [
  'first_name',
  'last_name'
];
my $value = [
  'Achmad Yusri',
  'Afandi'
];
my $clause = {
  where => 'id = 2'
};

# Preare Statement :
my $update = $sql_abstract->update($table_name, $column, $value, $clause);

# No Prepare Statement :
my $update = $sql_abstract->update($table_name, $column, $value, $clause, 'pre-st');
```
SQL equivalent :
```mysql
# Preare Statement :
UPDATE my_users SET first_name=?, last_name=? WHERE id = 2;

# No Prepare Statement :
UPDATE my_users SET first_name='Achmad Yusri', last_name='Afandi' WHERE id = 2;
```

### delete
```perl5
use CellBIS::SQL::Abstract
my $sql_abstract = CellBIS::SQL::Abstract->new;

my $table_name = 'my_users';
my $clause = {
  where => 'id = 2'
};
my $delete = $sql_abstract->delete($table_name, $clause);
```
SQL equivalent :
```mysql
DELETE FROM my_users WHERE id = 2;
```

### select
```perl5
use CellBIS::SQL::Abstract
my $sql_abstract = CellBIS::SQL::Abstract->new;

my $table_name = 'my_users';
my $column = [];
my $clause = {
  where => 'id = 2'
};
my $select = $sql_abstract->select($table_name, $column, $clause);
```
SQL equivalent :
```mysql
  SELECT * FROM my_users WHERE id = 2;
```
### select_join
```perl5
use CellBIS::SQL::Abstract
my $sql_abstract = CellBIS::SQL::Abstract->new;

my $table_list = [
  { name => 'my_users', 'alias' => 't1', primary => 1 },
  { name => 'my_companies', 'alias' => 't2' }
];
my $column = [
  't1.first_name',
  't1.last_name',
  't2.company_name',
];
my $clause = {
  'typejoin' => {
    'my_companies' => 'inner',
  },
  'join'     => [
    {
      name   => 'my_companies',
      onjoin => [
        't1.id', 't2.id_company_users',
      ]
    }
  ],
  'where'    => 't1.id = 2 AND t2.id_company_users = 1',
  'orderby'  => 't1.id',
  'order'    => 'desc', # asc || desc
  'limit'    => '10'
};
my $select_join = $sql_abstract->select_join($table_list, $column, $clause);
```
SQL equivalent :
```mysql
SELECT t1.first_name, t1.last_name, t2.company_name
FROM my_users AS t1
INNER JOIN my_companies AS t2
ON t1.id = t2.id_company_users
WHERE t1.id = 2 AND t2.id_company_users = 1 ORDER BY t1.id DESC LIMIT 10;
```