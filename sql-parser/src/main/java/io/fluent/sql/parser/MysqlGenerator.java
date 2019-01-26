package io.fluent.sql.parser;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.atn.PredictionMode;
import org.apache.commons.io.IOUtils;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class MysqlGenerator {
    public static void main(String[] args) throws IOException {
        if (args.length == 0) {
            System.err.println("no input file.");
            System.exit(1);
        }
        String path = args[0];
        FileInputStream fis = new FileInputStream(new File(path));
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        IOUtils.copy(fis, bos);
        String sqlFromFile = bos.toString("utf-8");

        List<String> strings = generateInsertSqlFrom(sqlFromFile);
        strings.forEach(s -> System.out.println(s));
    }

    public static List<String> generateInsertSqlFrom(String script) {
        final MySqlLexer sqlBaseLexer = new MySqlLexer(new CaseInsensitiveStream(CharStreams.fromString(script)));
        final CommonTokenStream tokenStream = new CommonTokenStream(sqlBaseLexer);
        final MySqlParser mySqlParser = new MySqlParser(tokenStream);
        mySqlParser.getInterpreter().setPredictionMode(PredictionMode.LL_EXACT_AMBIG_DETECTION);
        ParserErrorListener listener = new ParserErrorListener();
        mySqlParser.addErrorListener(listener);

        MySqlParser.StatementsContext statements = mySqlParser.statements();

        List<String> collect = statements.singleStatement().stream().map(singleStatementContext -> {
            TableNameVisitor tableNameVisitor = new TableNameVisitor();
            tableNameVisitor.visitSingleStatement(singleStatementContext);

            String tableName = tableNameVisitor.getTableName();

            ColumnNameVisitor columnNameVisitor = new ColumnNameVisitor();
            columnNameVisitor.visitSingleStatement(singleStatementContext);
            List<String> columnNames = columnNameVisitor.getColumnNames();

            return generateInsertSql(tableName, columnNames);
        }).collect(Collectors.toList());

        List<String> result = new ArrayList<>();
        result.addAll(listener.getErrorMessages());
        result.addAll(collect);
        return result;
    }

    public static String generateInsertSql(String tableName, List<String> columnNames) {
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
