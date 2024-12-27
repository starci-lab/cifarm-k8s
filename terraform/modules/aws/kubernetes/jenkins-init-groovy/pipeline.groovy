// Adds a pipeline job to Jenkins

import jenkins.model.Jenkins
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition
import org.jenkinsci.plugins.workflow.flow.FlowDefinition
import hudson.plugins.git.GitSCM
import hudson.plugins.git.BranchSpec
import hudson.plugins.git.UserRemoteConfig
import java.util.Collections
import com.cloudbees.jenkins.GitHubPushTrigger
import org.jenkinsci.plugins.workflow.job.properties.DisableConcurrentBuildsJobProperty

// Required plugins:
// - git
// - workflow-multibranch

// Variables
def jobName = "${job_name}"  // Job name
def jobDescription = "${job_description}"  // Job description
def jobScriptPath = "${job_script_path}"  // Path to the Jenkinsfile in the repository
def gitRepo = "${git_repo}"  // Git repository URL
def gitRepoName = "origin"  // Remote name, e.g., "origin"
def gitRepoBranch = "${git_repo_branch}"  // Branch pattern, e.g., "*/main" or "*"
def credentialsId = ""     // Leave empty if no credentials are required

// Get Jenkins instance
def jenkins = Jenkins.get()

// Check if the job already exists
def job = jenkins.getItemByFullName(jobName)
if (job != null) {
    // Print message and return
    println "Pipeline job '$${jobName}' already exists!"
    return
}

// Create the job
job = jenkins.createProject(WorkflowJob, jobName)

// Create the Git configuration
def userRemoteConfig = new UserRemoteConfig(gitRepo, gitRepoName, null, credentialsId)

// Branch specification (all branches or a specific one)
def branches = Collections.singletonList(new BranchSpec(gitRepoBranch))

// Define additional Git configuration (optional, can be left as null if not needed)
def doGenerateSubmoduleConfigurations = false
def submoduleCfg = null
def browser = null
def gitTool = null
def extensions = []

// Create GitSCM object
def scm = new GitSCM(
    [userRemoteConfig],                     // Repositories (Remote config)
    branches,                               // Branches
    doGenerateSubmoduleConfigurations,      // Generate submodule configurations
    submoduleCfg,                           // Submodule configurations (optional)
    browser,                                // Browser (optional)
    gitTool,                                // Git tool (optional)
    extensions                              // Git extensions (optional)
)

// Create the pipeline flow definition
def flowDefinition = new CpsScmFlowDefinition(scm, jobScriptPath)

// Add properties to the job
job.setDefinition(flowDefinition)
job.setDescription(jobDescription)

// Add the DisableConcurrentBuildsJobProperty to the job
def disableConcurrentBuildsJobProperty = new DisableConcurrentBuildsJobProperty()
disableConcurrentBuildsJobProperty.setAbortPrevious(true)
job.addProperty(disableConcurrentBuildsJobProperty)

// Add GitHub webhook trigger
job.addTrigger(new GitHubPushTrigger())
// Add SCM polling trigger (optional, you can uncomment this line if needed)
// job.addTrigger(new SCMTrigger("H/5 * * * *"))

// Save the job
job.save()

// Print success message
println "Pipeline job '$${jobName}' has been created successfully!"
