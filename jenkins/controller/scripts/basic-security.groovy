#!groovy

import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
def adminPassword = System.getenv("JENKINS_ADMIN_PASSWORD") ?: "admin123"

println "--> creating local user 'USERNAME'"

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin', adminPassword)
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()