package org.arksworld.eshop.aspect;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class LoggingAspect {

    private final Logger log = LoggerFactory.getLogger(this.getClass());

    // Pointcut for all controllers
    @Pointcut("within(org.arksworld.eshop..controller..*)")
    public void controllerMethods() {}

    // Pointcut for all services
    @Pointcut("within(org.arksworld.eshop..service..*)")
    public void serviceMethods() {}

    // Combine both
    @Pointcut("controllerMethods() || serviceMethods()")
    public void appFlow() {}

    // Before execution
    @Before("appFlow()")
    public void logBefore(JoinPoint joinPoint) {
        log.info("➡ Entering: {}.{}() with args={}",
                joinPoint.getSignature().getDeclaringTypeName(),
                joinPoint.getSignature().getName(),
                joinPoint.getArgs());
    }

    // After returning
    @AfterReturning(pointcut = "appFlow()", returning = "result")
    public void logAfterReturning(JoinPoint joinPoint, Object result) {
        log.info("⬅ Exiting: {}.{}() with result={}",
                joinPoint.getSignature().getDeclaringTypeName(),
                joinPoint.getSignature().getName(),
                result);
    }

    // After throwing exception
    @AfterThrowing(pointcut = "appFlow()", throwing = "ex")
    public void logAfterThrowing(JoinPoint joinPoint, Throwable ex) {
        log.error("❌ Exception in {}.{}() with cause={}",
                joinPoint.getSignature().getDeclaringTypeName(),
                joinPoint.getSignature().getName(),
                ex.getMessage(), ex);
    }
}
