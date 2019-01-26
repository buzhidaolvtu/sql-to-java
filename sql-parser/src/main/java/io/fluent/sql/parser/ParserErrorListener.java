package io.fluent.sql.parser;

import org.antlr.v4.runtime.ANTLRErrorListener;
import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;

import java.util.ArrayList;
import java.util.List;

public class ParserErrorListener extends BaseErrorListener implements ANTLRErrorListener {

    private List<String> errorMessages = new ArrayList<>();

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
        errorMessages.add("line " + line + ":" + charPositionInLine + " " + msg);
    }

    public List<String> getErrorMessages() {
        return errorMessages;
    }
}
