import jenkins.model.*
import org.csanchez.jenkins.plugins.kubernetes.*

// define the Jenkins instance
def jenkins = Jenkins.getInstance()
        
// define the Kubernetes cloud
def kubernetesCloud = new KubernetesCloud("cifarm-kubernetes", null, null, "jenkins", null, "10", 5, 10, 5)
kubernetesCloud.setSkipTlsVerify(true)
kubernetesCloud.setJenkinsUrl("http://jenkins.jenkins.svc.cluster.local")
kubernetesCloud.setWebSocket(true)

// add the Kubernetes cloud to the Jenkins instance, and save the configuration
jenkins.clouds.add(kubernetesCloud)
jenkins.save()