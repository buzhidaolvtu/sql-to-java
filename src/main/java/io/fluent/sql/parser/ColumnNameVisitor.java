package io.fluent.sql.parser;

import java.util.ArrayList;
import java.util.List;

public class ColumnNameVisitor extends MySqlBaseVisitor {

    private List<String> columnNames = new ArrayList<>();

    @Override
    public Object visitColumnDefinition(MySqlParser.ColumnDefinitionContext ctx) {
        columnNames.add(ctx.col_name().getText());
        return super.visitColumnDefinition(ctx);
    }

    public List<String> getColumnNames() {
        return columnNames;
    }
}
