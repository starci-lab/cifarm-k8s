// Import necessary classes
import jenkins.model.Jenkins
import org.csanchez.jenkins.plugins.kubernetes.KubernetesCloud

// Define the Jenkins instance
Jenkins jenkins = Jenkins.get()  // Using Jenkins.get() for newer Jenkins versions

// Define the cloud name
def cloudName = "cifarm-kubernetes"

// Create the KubernetesCloud configuration
KubernetesCloud kubernetesCloud = new KubernetesCloud(cloudName)  // Name of the Kubernetes cloud configuration
kubernetesCloud.setNamespace("jenkins")                         // Kubernetes namespace
kubernetesCloud.setSkipTlsVerify(true)                          // Skip TLS verification (true if you want to disable it)
kubernetesCloud.setJenkinsUrl("http://jenkins.jenkins.svc.cluster.local") // Jenkins internal URL in Kubernetes
kubernetesCloud.setWebSocket(true)                              // Use WebSocket for communication with Jenkins agents

// Add the Kubernetes cloud configuration to Jenkins
jenkins.clouds.add(kubernetesCloud)

// Save the Jenkins configuration
jenkins.save()

// Print confirmation
println "Kubernetes cloud '${cloudName}' has been successfully added to Jenkins."
