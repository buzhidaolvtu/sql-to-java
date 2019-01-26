package io.fluent.sql.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;

@Configuration
@EnableAspectJAutoProxy
@EnableScheduling
public class WebConfigure extends WebMvcConfigurationSupport {


    @Override
    protected void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("*")
                .allowedMethods("*")
                .allowCredentials(true)
                .maxAge(3600);
    }


    /**
     * 如果重载这个方法了，那么好像就需要把handler和location都配置一下。thymeleaf的自动配置和这里没有关系。
     * https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-spring-mvc-static-content
     * @param registry
     */
    @Override
    protected void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")//只有"**"部分会被添加到如下位置，如：
                .addResourceLocations("classpath:/templates/")///static/js/abx.js,那么classpath:/templates/js/abx.js会被查找
                .setCachePeriod(31556926);
    }


}
