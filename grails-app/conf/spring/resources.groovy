import au.org.ala.volunteer.ApplicationContextHolder
import au.org.ala.volunteer.BVPServletFilter
import au.org.ala.volunteer.DigivolServletContextConfig
import au.org.ala.volunteer.EventSourceServlet
import au.org.ala.volunteer.collectory.CollectoryClientFactoryBean
import org.springframework.boot.web.servlet.FilterRegistrationBean
import org.springframework.boot.web.servlet.ServletRegistrationBean

// Place your Spring DSL code here
beans = {
//    customPageRenderer(CustomPageRenderer, ref("groovyPagesTemplateEngine")) {
//        groovyPageLocator = ref("groovyPageLocator")
//    }

    collectoryClient(CollectoryClientFactoryBean) {
        endpoint = 'http://collections.ala.org.au/ws/'
    }

//    bvpSecurePluginFilter(BVPSecurePluginFilter) {
//        securityPrimitives = ref("securityPrimitives")
//    }

    applicationContextHolder(ApplicationContextHolder) { bean ->
        bean.factoryMethod = 'getInstance'
    }

    digivolServletContextConfig(DigivolServletContextConfig)

    bvpServletFilter(FilterRegistrationBean) {
        name = 'BVPServletFilter'
        filter = bean(BVPServletFilter)
        urlPatterns = [ '/*' ]
        asyncSupported = true
    }

    eventSourceServlet(ServletRegistrationBean) {
        name = 'eventSource'
        servlet = bean(EventSourceServlet)
        urlMappings = [ '/es' ]
        asyncSupported = true
    }

}
