package com.mycompany.java;

import hudson.model.*;
import hudson.plugins.git.*;
import hudson.triggers.SCMTrigger;
import hudson.triggers.SCMTrigger.*;

import java.io.IOException;
import java.net.URISyntaxException;
import java.util.Collections;
import jenkins.model.*;
import org.eclipse.jgit.transport.*;
import org.jenkinsci.plugins.workflow.job.*;
import com.cloudbees.jenkins.*;
/**
 *
 * @author cuong
 */
public class BuildPipelineExample {
    public static void main(String[] args) throws IOException, Descriptor.FormException, URISyntaxException, URISyntaxException {
        String pipelineName = "hello_world_pipeline";
        String jobDescription = "Pipeline job";
        String jobScript = "example/Jenkinsfile";
        String gitRepo = "https://github.com/starci-lab/cifarm-containers.git";
        String branch = "/example";
        var jenkins = Jenkins.getInstance();
        
        var job = (WorkflowJob) jenkins.getItem(pipelineName);
        
        if (job != null) {
            job = jenkins.createProject(WorkflowJob.class, pipelineName);
            
            var remoteConfig = new RemoteConfig(null, gitRepo);
            // Create BranchSpec for the desired branch
            var branchSpec = new BranchSpec(branch);
            // Create GitSCM object
            var gitSCM = new GitSCM(
                Collections.singletonList(remoteConfig),    // repositories (required)
                Collections.singletonList(branchSpec),      // branches (required)
                null,                                       // mergeOptions (default: null)
                false,                                      // doGenerateSubmoduleConfigurations (default: false)
                Collections.emptyList(),                    // submoduleCfg (default: empty collection)
                false,                                      // clean (default: false)
                false,                                      // wipeOutWorkspace (default: false)
                null,                                       // buildChooser (default: null)
                null,                                       // browser (default: null)
                null,                                       // gitTool (default: null)
                true,                                       // authorOrCommitter (default: true)
                "",                                         // excludedRegions (default: empty string)
                "",                                         // excludedUsers (default: empty string)
                "refs/heads/main",                          // localBranch (set to branch name, e.g., "refs/heads/main")
                true,                                       // recursiveSubmodules (default: true)
                false,                                      // pruneBranches (default: false)
                "starci183",                                // gitConfigName (default: user name)
                "cuongnvtse160875@gmail.com",               // gitConfigEmail (default: user email)
                false,                                      // skipTag (default: false)
                ""                                          // includedRegions (default: empty string)
            );
            
            job.setDescription(jobDescription);
            job.setDefinition(new CpsScmFlowDefinition(gitSCM, jobScript));
            job.addTrigger(new Trigger);
            job.save();
        }
    }
}
