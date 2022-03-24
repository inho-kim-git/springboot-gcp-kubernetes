package com.springboot.kubernetes.google.service.kubernetes;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @Description 쿠버네티스 인그레스 상태 체크 확인 Rest
 *
 * @Date 2022/03/21
 * @Author inho.kim
 */
@RestController
@Slf4j
public class HealthCheckRest {

    @RequestMapping("/health")
    public String healthCheckRest() {
        return "200 Ok.";
    }
}
