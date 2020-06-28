#!/bin/sh

MYSQL="mysql -u isucon"

$MYSQL <<EOF
USE isucon;
ALTER TABLE memos ADD INDEX index_user(user);
ALTER TABLE memos ADD INDEX index_is_private(is_private);
EOF