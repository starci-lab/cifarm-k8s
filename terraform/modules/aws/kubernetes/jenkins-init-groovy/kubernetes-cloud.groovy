// Import necessary classes
import jenkins.model.Jenkins
import org.csanchez.jenkins.plugins.kubernetes.KubernetesCloud
import org.csanchez.jenkins.plugins.kubernetes.PodTemplate
import org.csanchez.jenkins.plugins.kubernetes.ContainerTemplate

// Define the variables
def nodeSelector = "${node_selector}"
def namespace = "${namespace}"
def build_agent_yaml = '''${build_agent_yaml}'''

// Define the cloud name
def cloudName = "cifarm-kubernetes"
// Define the Jenkins instance
def jenkins = Jenkins.get()  // Using Jenkins.get() for newer Jenkins versions

// Check if the Kubernetes cloud already exists
if (jenkins.clouds.find { it.name == cloudName }) {
    // Print confirmation
    println "Kubernetes cloud '$${cloudName}' already exists in Jenkins."
    // Skip the rest of the script
    return
}

// Create the KubernetesCloud configuration
def kubernetesCloud = new KubernetesCloud(cloudName)  // Name of the Kubernetes cloud configuration
kubernetesCloud.setNamespace(namespace)                         // Kubernetes namespace
kubernetesCloud.setSkipTlsVerify(true)                          // Skip TLS verification (true if you want to disable it)
kubernetesCloud.setJenkinsUrl("http://jenkins.jenkins.svc.cluster.local") // Jenkins internal URL in Kubernetes
kubernetesCloud.setWebSocket(true)                              // Use WebSocket for communication with Jenkins agents

// Create pod templates
def podTemplate = new PodTemplate()
podTemplate.setName("Build Agent")
podTemplate.setLabel("build-agent")  // Label for the pod template
podTemplate.setNamespace(namespace)
podTemplate.setNodeSelector(nodeSelector) // Node selector for the pod template

// Set yaml
podTemplate.setYaml(build_agent_yaml)

// Add the pod template to the Kubernetes cloud configuration
kubernetesCloud.addTemplate(podTemplate)

// Add the Kubernetes cloud configuration to Jenkins
jenkins.clouds.add(kubernetesCloud)

// Save the Jenkins configuration
jenkins.save()

// Print confirmation
println "Kubernetes cloud '$${cloudName}' has been successfully added to Jenkins."
