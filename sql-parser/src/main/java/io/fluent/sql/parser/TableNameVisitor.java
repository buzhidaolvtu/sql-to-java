package io.fluent.sql.parser;

public class TableNameVisitor extends MySqlBaseVisitor {


    private String tableName;

    @Override
    public Object visitCreateTable(MySqlParser.CreateTableContext ctx) {
        tableName = ctx.tbl_name().getText();
        return super.visitCreateTable(ctx);
    }

    public String getTableName() {
        return tableName;
    }
}
