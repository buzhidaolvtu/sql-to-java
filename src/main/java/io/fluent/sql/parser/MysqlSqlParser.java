package io.fluent.sql.parser;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.atn.PredictionMode;
import org.apache.commons.io.IOUtils;

import java.io.*;
import java.util.List;
import java.util.stream.Collectors;

public class MysqlSqlParser {
    public static void main(String[] args) throws IOException {
        String path = args[0];
        FileInputStream fis = new FileInputStream(new File(path));
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        IOUtils.copy(fis, bos);
        String sqlFromFile = bos.toString("utf-8");

        final MySqlLexer sqlBaseLexer = new MySqlLexer(new CaseInsensitiveStream(CharStreams.fromString(sqlFromFile)));
        final CommonTokenStream tokenStream = new CommonTokenStream(sqlBaseLexer);
        final MySqlParser mySqlParser = new MySqlParser(tokenStream);
        mySqlParser.getInterpreter().setPredictionMode(PredictionMode.LL_EXACT_AMBIG_DETECTION);

        MySqlParser.StatementsContext statements = mySqlParser.statements();

        statements.singleStatement().forEach(singleStatementContext -> {
            TableNameVisitor tableNameVisitor = new TableNameVisitor();
            tableNameVisitor.visitSingleStatement(singleStatementContext);

            String tableName = tableNameVisitor.getTableName();

            ColumnNameVisitor columnNameVisitor = new ColumnNameVisitor();
            columnNameVisitor.visitSingleStatement(singleStatementContext);
            List<String> columnNames = columnNameVisitor.getColumnNames();

            System.out.println(generateInsertSql(tableName, columnNames));
        });
    }

    private static String generateInsertSql(String tableName, List<String> columnNames) {
        StringBuilder stringBuilder = new StringBuilder(200);
        stringBuilder.append("insert into ")
                .append(tableName.replaceAll("`", ""))
                .append("(")
                .append(columnNames.stream().filter(columnName -> !columnName.replaceAll("`", "").equalsIgnoreCase("id")).map(columnName -> columnName.replaceAll("`", "")).collect(Collectors.joining(",")))
                .append(") values (")
                .append(columnNames.stream().filter(columnName -> !columnName.replaceAll("`", "").equalsIgnoreCase("id")).map(columnName -> "#{" + StringUtil.toCamelCaseName(columnName.replaceAll("`", "")) + "}").collect(Collectors.joining(",")))
                .append(")");
        return stringBuilder.toString();
    }
}
