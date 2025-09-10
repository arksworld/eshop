package org.arksworld.eshop.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class LoggingAspect {

    private final Logger log = LoggerFactory.getLogger(LoggingAspect.class);
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Pointcut("within(org.arksworld.eshop.web.controller.*) || within(org.arksworld.eshop.web.security.*)")
    public void appFlow() {}

    @Before("appFlow()")
    public void logBefore(JoinPoint joinPoint) {
        try {
            String argsJson = objectMapper.writeValueAsString(joinPoint.getArgs());
            log.info("➡ Entering: {}.{}() with args={}",
                    joinPoint.getSignature().getDeclaringTypeName(),
                    joinPoint.getSignature().getName(),
                    argsJson);
        } catch (Exception e) {
            log.warn("Could not serialize args for logging", e);
        }
    }

    @AfterReturning(pointcut = "appFlow()", returning = "result")
    public void logAfterReturning(JoinPoint joinPoint, Object result) {
        try {
            String resultJson = objectMapper.writeValueAsString(result);
            log.info("⬅ Exiting: {}.{}() with result={}",
                    joinPoint.getSignature().getDeclaringTypeName(),
                    joinPoint.getSignature().getName(),
                    resultJson);
        } catch (Exception e) {
            log.warn("Could not serialize result for logging", e);
        }
    }

    @AfterThrowing(pointcut = "appFlow()", throwing = "ex")
    public void logAfterThrowing(JoinPoint joinPoint, Throwable ex) {
        log.error("❌ Exception in {}.{}() with cause={}",
                joinPoint.getSignature().getDeclaringTypeName(),
                joinPoint.getSignature().getName(),
                ex.getMessage(), ex);
    }
}
