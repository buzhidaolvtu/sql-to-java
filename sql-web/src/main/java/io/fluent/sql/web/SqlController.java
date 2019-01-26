package io.fluent.sql.web;

import io.fluent.sql.parser.MysqlGenerator;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@CrossOrigin
@Controller()
@RequestMapping("/sql")
public class SqlController {


    @RequestMapping(value = {"/",""})
    public String index() {
        return "index";
    }

    @RequestMapping("/script")
    @ResponseBody
    public String generateInsertSql(@RequestBody String script) {
        List<String> strings = MysqlGenerator.generateInsertSqlFrom(script);
        return StringUtils.join(strings, "\n");
    }

}
