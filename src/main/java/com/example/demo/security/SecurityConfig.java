package com.example.demo.security;

import java.security.Key;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authorization.AuthorizationDecision;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;

import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
	
	private static final Key SECRET_KEY = Keys.secretKeyFor(SignatureAlgorithm.HS256);

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }


    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
        .csrf(csrf -> csrf.disable())
        .authorizeHttpRequests(authorize -> authorize
        		.requestMatchers("/home/index").permitAll()
                .requestMatchers("/home/**").access((authentication, context) -> 
                        new AuthorizationDecision(
                                authentication.get().getAuthorities().stream()
                                .noneMatch(grantedAuthority -> "ROLE_ADMIN".equals(grantedAuthority.getAuthority()))
                        )
                )
                .requestMatchers("/resources/**", "/static/**", "/css/**", "/js/**", "/imgs/**").permitAll()
        		.requestMatchers("/apiclient/**").hasAuthority("ROLE_USER")
                .requestMatchers("/auth/registerForm/**").permitAll()
                .requestMatchers("/auth/register/**").permitAll()
                .requestMatchers("/admin/**").hasAuthority("ROLE_ADMIN")
                .anyRequest().authenticated()
            )		
        .formLogin(form -> form
                .loginPage("/auth/login") // Página de login personalizada
                .defaultSuccessUrl("/home/index", true) // Redirigir tras login exitoso
                .permitAll()
            )
        .logout(logout -> logout.permitAll()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/auth/login?logout")
            )
        .addFilterBefore(new JWTAuthorizationFilter(SECRET_KEY), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
    
    public static Key getSecretKey() {
        return SECRET_KEY;
    }

    



	
}
