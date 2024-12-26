import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl
import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.CredentialsProvider
import com.cloudbees.plugins.credentials.domains.Domain
import hudson.util.Secret
import org.jenkinsci.plugins.github.config.GitHubPluginConfig
import org.jenkinsci.plugins.github.config.GitHubServerConfig
import jenkins.model.Jenkins
import com.cloudbees.plugins.credentials.SystemCredentialsProvider
import org.jenkinsci.plugins.github.config.HookSecretConfig

// configure credentials
String credentialsId = "${credentials_id}"
String credentialsDescription = "${credentials_description}"
String accessToken = "${access_token}"

// configure secret
String secretId = "${secret_id}"
String secretDescription = "${secret_description}"
String secret = "${secret}"

// configure github server name
String serverName = "${server_name}"

Domain domain = Domain.global()

// create jenkins instance
SystemCredentialsProvider.StoreImpl store = Jenkins.get().getExtensionList(SystemCredentialsProvider.class)[0].getStore()
if (store.getCredentials(domain).find { it.id == credentialsId } == null) {
  StringCredentialsImpl credentialsText = new StringCredentialsImpl(
        CredentialsScope.GLOBAL,
        credentialsId,
        credentialsDescription,
        Secret.fromString(accessToken)
  )
  store.addCredentials(domain, credentialsText)
}

// configure github plugin
GitHubPluginConfig github = Jenkins.get().getExtensionList(GitHubPluginConfig.class)[0]

// configure github server
GitHubServerConfig githubServerConfig = new GitHubServerConfig(credentialsId)
githubServerConfig.setName(serverName)  // Set the name of the GitHub server for easy identification

// configure hook secret
if (store.getCredentials(domain).find { it.id == secretId } == null) {
 StringCredentialsImpl secretText = new StringCredentialsImpl(
        CredentialsScope.GLOBAL,
        secretId,
        secretDescription,
        Secret.fromString(secret)
  )
  store.addCredentials(domain, credentialsText)
}

// create hook secret configuration
HookSecretConfig hookSecretConfig = new HookSecretConfig(secretId)

// set configurations
github.setConfigs([
  githubServerConfig,
  hookSecretConfig
])

// save configurations
github.save()

println "GitHub credentials have been successfully configured."