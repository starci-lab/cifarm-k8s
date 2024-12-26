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

// configure hook secret
String hookSecretId = "${hook_secret_id}"
String hookSecretDescription = "${hook_secret_description}"
String hookSecret = "${hook_secret}"

// configure github server name
String serverName = "${server_name}"

Domain domain = Domain.global()

// create jenkins instance
SystemCredentialsProvider.StoreImpl store = Jenkins.get().getExtensionList(SystemCredentialsProvider.class)[0].getStore()

// Add GitHub access token if not already present
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

// Add hook secret if not already present
if (store.getCredentials(domain).find { it.id == hookSecretId } == null) {
  StringCredentialsImpl hookSecretText = new StringCredentialsImpl(
        CredentialsScope.GLOBAL,
        hookSecretId,
        hookSecretDescription,
        Secret.fromString(hookSecret)
  )
  store.addCredentials(domain, hookSecretText)
}

// create hook secret configuration
HookSecretConfig hookSecretConfig = new HookSecretConfig(hookSecretId)

// set configurations
github.setConfigs([
  githubServerConfig,
  hookSecretConfig
])

// save configurations
github.save()

println "GitHub credentials and hook secret have been successfully configured."
