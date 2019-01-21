/*
 * Copyright 2018 Confluent Inc.
 *
 * Licensed under the Confluent Community License; you may not use this file
 * except in compliance with the License.  You may obtain a copy of the License at
 *
 * http://www.confluent.io/confluent-community-license
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OF ANY KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations under the License.
 */

grammar MySql;

statements
    : (singleStatement)* EOF
    ;

singleStatement
    : statement ';'
    ;

statement
    :create_table
    ;

create_table:
    CREATE (TEMPORARY)? TABLE (IF NOT EXISTS)? tbl_name '('
        create_definition (',' create_definition)*
        ')' table_options?  #createTable
    ;

create_definition:
       col_name column_definition #columnDefinition
    | (CONSTRAINT symbol?)? PRIMARY KEY index_type? key_parts index_option* #primaryKeyDefinition
    | (INDEX|KEY) index_name? index_type? key_parts index_option* #indexDefinition
    | (CONSTRAINT symbol?)? UNIQUE (INDEX|KEY) index_name? index_type? key_parts index_option* #uniqueKeyDefinition
    | (FULLTEXT|SPATIAL) (INDEX|KEY) index_name? key_parts index_option* #specialKeyDefinition
    | (CONSTRAINT symbol?)? FOREIGN KEY index_name? key_parts reference_definition #foreignKeyDefinition
    ;

key_parts:
    '(' key_part (',' key_part)* ')'
    ;

column_definition:
    data_type (NOT NULL | NULL)? (DEFAULT default_value)?
        AUTO_INCREMENT? (UNIQUE KEY?)? (PRIMARY? KEY)?
        (COMMENT STRING)?
        (COLUMN_FORMAT (FIXED|DYNAMIC|DEFAULT))?
        (STORAGE (DISK|MEMORY|DEFAULT))?
        (reference_definition)?
    ;

data_type:
    TINYINT ('(' length ')' )?
    |SMALLINT ('(' length ')' )?
    |MEDIUMINT ('(' length ')' )?
    |INT ('(' length ')' )?
    |BIGINT ('(' length ')' )?
    |DECIMAL '(' length ',' length ')'
    |NUMERIC
    |FLOAT
    |DOUBLE
    |DATE
    |TIME
    |DATETIME
    |TIMESTAMP
    |YEAR
    |CHAR '(' length ')'
    |VARCHAR '(' length ')'
    ;

key_part:
    col_name length? (ASC | DESC)?
    ;

index_type:
    USING (BTREE | HASH)
    ;

index_option:
    KEY_BLOCK_SIZE EQ? value
    | index_type
    | WITH PARSER parser_name
    | COMMENT STRING
    ;

reference_definition:
    REFERENCES tbl_name key_parts
    (MATCH FULL | MATCH PARTIAL | MATCH SIMPLE)?
    (ON DELETE reference_option)?
    (ON UPDATE reference_option)?
    ;

reference_option:
    RESTRICT | CASCADE | SET NULL | NO ACTION | SET DEFAULT
    ;

table_options:
    table_option+
    ;

table_option:
    AUTO_INCREMENT EQ? value
    | AVG_ROW_LENGTH EQ? value
    | DEFAULT? (CHARACTER SET|CHARSET) EQ? charset_name
    | CHECKSUM EQ? DIGIT
    | DEFAULT? COLLATE EQ? collation_name
    | COMMENT EQ? STRING
    | COMPRESSION EQ? ('ZLIB'|'LZ4'|'NONE')
    | CONNECTION EQ? STRING
    | (DATA|INDEX) DIRECTORY EQ? STRING
    | DELAY_KEY_WRITE EQ? DIGIT
    | ENCRYPTION EQ? ('Y' | 'N')
    | ENGINE EQ? engine_name
    | INSERT_METHOD EQ? ( NO | FIRST | LAST )
    | KEY_BLOCK_SIZE EQ? value
    | MAX_ROWS EQ? value
    | MIN_ROWS EQ? value
    | PACK_KEYS EQ? (DIGIT | DEFAULT)
    | PASSWORD EQ? STRING
    | ROW_FORMAT EQ? (DEFAULT|DYNAMIC|FIXED|COMPRESSED|REDUNDANT|COMPACT)
    | STATS_AUTO_RECALC EQ? (DEFAULT|DIGIT)
    | STATS_PERSISTENT EQ? (DEFAULT|DIGIT)
    | STATS_SAMPLE_PAGES EQ? value
    | TABLESPACE tablespace_name (STORAGE (DISK|MEMORY|DEFAULT))?
    | UNION EQ? (tbl_name (',' tbl_name)*)
    ;

default_value
    :value
    ;

value
    :STRING
    |(PLUS|MINUS)? number
    ;

length
    :INTEGER_VALUE
    ;

symbol
    :identifier
    ;

index_name
    :identifier
    ;

tbl_name
    :identifier
    ;

parser_name
    :identifier
    ;

charset_name
    :identifier
    ;

collation_name
    :identifier
    ;

engine_name
    :identifier
    ;

tablespace_name
    :identifier
    ;

col_name
    :identifier
    ;

timeZoneSpecifier
    : TIME ZONE STRING    #timeZoneString
    ;

comparisonOperator
    : EQ | NEQ | LT | LTE | GT | GTE
    ;

booleanValue
    : TRUE | FALSE
    ;

type
    : type ARRAY
    | ARRAY '<' type '>'
    | MAP '<' type ',' type '>'
    | STRUCT '<' identifier type (',' identifier type)* '>'
    | baseType ('(' typeParameter (',' typeParameter)* ')')?
    ;

typeParameter
    : INTEGER_VALUE | type
    ;

baseType
    : identifier
    ;

qualifiedName
    : identifier ('.' identifier)*
    ;

identifier
    : IDENTIFIER             #unquotedIdentifier
    | QUOTED_IDENTIFIER      #quotedIdentifierAlternative
    | nonReserved            #unquotedIdentifier
    | BACKQUOTED_IDENTIFIER  #backQuotedIdentifier
    | DIGIT_IDENTIFIER       #digitIdentifier
    ;

number
    : DECIMAL_VALUE  #decimalLiteral
    | INTEGER_VALUE  #integerLiteral
    ;

nonReserved
    : SHOW | TABLES | COLUMNS | COLUMN | PARTITIONS | FUNCTIONS | FUNCTION | SESSION
    | STRUCT | MAP | ARRAY | PARTITION
    | INTEGER | DATE | TIME | TIMESTAMP | INTERVAL | ZONE
    | YEAR | MONTH | DAY | HOUR | MINUTE | SECOND
    | EXPLAIN | ANALYZE | TYPE
    | SET | RESET
    | IF
    ;

SELECT: 'SELECT';
FROM: 'FROM';
AS: 'AS';
ALL: 'ALL';
DISTINCT: 'DISTINCT';
WHERE: 'WHERE';
WITHIN: 'WITHIN';
WINDOW: 'WINDOW';
GROUP: 'GROUP';
BY: 'BY';
HAVING: 'HAVING';
LIMIT: 'LIMIT';
AT: 'AT';
OR: 'OR';
AND: 'AND';
IN: 'IN';
NOT: 'NOT';
EXISTS: 'EXISTS';
BETWEEN: 'BETWEEN';
LIKE: 'LIKE';
IS: 'IS';
NULL: 'NULL';
TRUE: 'TRUE';
FALSE: 'FALSE';
INTEGER: 'INTEGER';
DATE: 'DATE';
TIME: 'TIME';
TIMESTAMP: 'TIMESTAMP';
INTERVAL: 'INTERVAL';
YEAR: 'YEAR';
MONTH: 'MONTH';
DAY: 'DAY';
HOUR: 'HOUR';
MINUTE: 'MINUTE';
SECOND: 'SECOND';
MILLISECOND: 'MILLISECOND';
YEARS: 'YEARS';
MONTHS: 'MONTHS';
DAYS: 'DAYS';
HOURS: 'HOURS';
MINUTES: 'MINUTES';
SECONDS: 'SECONDS';
MILLISECONDS: 'MILLISECONDS';
ZONE: 'ZONE';
TUMBLING: 'TUMBLING';
HOPPING: 'HOPPING';
SIZE: 'SIZE';
ADVANCE: 'ADVANCE';
CASE: 'CASE';
WHEN: 'WHEN';
THEN: 'THEN';
ELSE: 'ELSE';
END: 'END';
JOIN: 'JOIN';
FULL: 'FULL';
OUTER: 'OUTER';
INNER: 'INNER';
LEFT: 'LEFT';
RIGHT: 'RIGHT';
ON: 'ON';
PARTITION: 'PARTITION';
STRUCT: 'STRUCT';
WITH: 'WITH';
VALUES: 'VALUES';
CREATE: 'CREATE';
REGISTER: 'REGISTER';
TABLE: 'TABLE';
TOPIC: 'TOPIC';
STREAM: 'STREAM';
STREAMS: 'STREAMS';
INSERT: 'INSERT';
DELETE: 'DELETE';
INTO: 'INTO';
DESCRIBE: 'DESCRIBE';
EXTENDED: 'EXTENDED';
PRINT: 'PRINT';
EXPLAIN: 'EXPLAIN';
ANALYZE: 'ANALYZE';
TYPE: 'TYPE';
CAST: 'CAST';
SHOW: 'SHOW';
LIST: 'LIST';
TABLES: 'TABLES';
TOPICS: 'TOPICS';
REGISTERED: 'REGISTERED';
QUERY: 'QUERY';
QUERIES: 'QUERIES';
TERMINATE: 'TERMINATE';
LOAD: 'LOAD';
COLUMNS: 'COLUMNS';
COLUMN: 'COLUMN';
PARTITIONS: 'PARTITIONS';
FUNCTIONS: 'FUNCTIONS';
FUNCTION: 'FUNCTION';
DROP: 'DROP';
TO: 'TO';
RENAME: 'RENAME';
ARRAY: 'ARRAY';
MAP: 'MAP';
SET: 'SET';
RESET: 'RESET';
SESSION: 'SESSION';
SAMPLE: 'SAMPLE';
EXPORT: 'EXPORT';
CATALOG: 'CATALOG';
PROPERTIES: 'PROPERTIES';
BEGINNING: 'BEGINNING';
UNSET: 'UNSET';
RUN: 'RUN';
SCRIPT: 'SCRIPT';

IF: 'IF';


TEMPORARY:'TEMPORARY';
CONSTRAINT:'CONSTRAINT';
PRIMARY:'PRIMARY';
KEY:'KEY';
INDEX:'INDEX';
UNIQUE:'UNIQUE';
FULLTEXT:'FULLTEXT';
SPATIAL:'SPATIAL';
FOREIGN:'FOREIGN';
DEFAULT:'DEFAULT';
AUTO_INCREMENT:'AUTO_INCREMENT';
COMMENT:'COMMENT';
COLUMN_FORMAT:'COLUMN_FORMAT';
FIXED:'FIXED';
DYNAMIC:'DYNAMIC';
STORAGE:'STORAGE';
DISK:'DISK';
MEMORY:'MEMORY';
TINYINT:'TINYINT';
SMALLINT:'SMALLINT';
MEDIUMINT:'MEDIUMINT';
INT:'INT';
BIGINT:'BIGINT';
DECIMAL:'DECIMAL';
NUMERIC:'NUMERIC';
FLOAT:'FLOAT';
DOUBLE:'DOUBLE';
DATETIME:'DATETIME';
CHAR:'CHAR';
VARCHAR:'VARCHAR';
ASC:'ASC';
DESC:'DESC';
USING:'USING';
BTREE:'BTREE';
HASH:'HASH';
KEY_BLOCK_SIZE:'KEY_BLOCK_SIZE';
PARSER:'PARSER';
REFERENCES:'REFERENCES';
MATCH:'MATCH';
PARTIAL:'PARTIAL';
SIMPLE:'SIMPLE';
UPDATE:'UPDATE';
RESTRICT:'RESTRICT';
CASCADE:'CASCADE';
NO:'NO';
ACTION:'ACTION';
AVG_ROW_LENGTH:'AVG_ROW_LENGTH';
CHARACTER:'CHARACTER';
CHARSET:'CHARSET';
CHECKSUM:'CHECKSUM';
COLLATE:'COLLATE';
COMPRESSION:'COMPRESSION';
CONNECTION:'CONNECTION';
DATA:'DATA';
DIRECTORY:'DIRECTORY';
DELAY_KEY_WRITE:'DELAY_KEY_WRITE';
ENCRYPTION:'ENCRYPTION';
ENGINE:'ENGINE';
INSERT_METHOD:'INSERT_METHOD';
FIRST:'FIRST';
LAST:'LAST';
MAX_ROWS:'MAX_ROWS';
MIN_ROWS:'MIN_ROWS';
PACK_KEYS:'PACK_KEYS';
PASSWORD:'PASSWORD';
ROW_FORMAT:'ROW_FORMAT';
COMPRESSED:'COMPRESSED';
REDUNDANT:'REDUNDANT';
COMPACT:'COMPACT';
STATS_AUTO_RECALC:'STATS_AUTO_RECALC';
STATS_PERSISTENT:'STATS_PERSISTENT';
STATS_SAMPLE_PAGES:'STATS_SAMPLE_PAGES';
TABLESPACE:'TABLESPACE';
UNION:'UNION';


EQ  : '=';
NEQ : '<>' | '!=';
LT  : '<';
LTE : '<=';
GT  : '>';
GTE : '>=';

PLUS: '+';
MINUS: '-';
ASTERISK: '*';
SLASH: '/';
PERCENT: '%';
CONCAT: '||';

STRUCT_FIELD_REF: '->';

STRING
    : '\'' ( ~'\'' | '\'\'' )* '\''
    ;

// Note: we allow any character inside the binary literal and validate
// its a correct literal when the AST is being constructed. This
// allows us to provide more meaningful error messages to the user
BINARY_LITERAL
    :  'X\'' (~'\'')* '\''
    ;

INTEGER_VALUE
    : DIGIT+
    ;

DECIMAL_VALUE
    : DIGIT+ '.' DIGIT*
    | '.' DIGIT+
    | DIGIT+ ('.' DIGIT*)? EXPONENT
    | '.' DIGIT+ EXPONENT
    ;

IDENTIFIER
    : (LETTER | '_') (LETTER | DIGIT | '_' | '@' )*
    ;

DIGIT_IDENTIFIER
    : DIGIT (LETTER | DIGIT | '_' | '@' )+
    ;

QUOTED_IDENTIFIER
    : '"' ( ~'"' | '""' )* '"'
    ;

BACKQUOTED_IDENTIFIER
    : '`' ( ~'`' | '``' )* '`'
    ;

TIME_WITH_TIME_ZONE
    : 'TIME' WS 'WITH' WS 'TIME' WS 'ZONE'
    ;

TIMESTAMP_WITH_TIME_ZONE
    : 'TIMESTAMP' WS 'WITH' WS 'TIME' WS 'ZONE'
    ;

fragment EXPONENT
    : 'E' [+-]? DIGIT+
    ;

fragment DIGIT
    : [0-9]
    ;

fragment LETTER
    : [A-Z]
    ;

SIMPLE_COMMENT
    : '--' ~[\r\n]* '\r'? '\n'? -> channel(HIDDEN)
    ;

DESCRIPTION_COMMENT
    : '#' ~[\r\n]* '\r'? '\n'? -> channel(HIDDEN)
    ;

BRACKETED_COMMENT
    : '/*' .*? '*/' -> channel(HIDDEN)
    ;

WS
    : [ \r\n\t]+ -> channel(HIDDEN)
    ;

// Catch-all for anything we can't recognize.
// We use this to be able to ignore and recover all the text
// when splitting statements with DelimiterLexer
UNRECOGNIZED
    : .
    ;
