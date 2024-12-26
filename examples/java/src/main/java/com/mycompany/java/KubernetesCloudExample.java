/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package com.mycompany.java;

import java.io.IOException;
import jenkins.model.*;
import org.csanchez.jenkins.plugins.kubernetes.*;
/**
 *
 * @author cuong
 */
public class KubernetesCloudExample {

    public static void main(String[] args) throws IOException {
        var jenkins = Jenkins.get();
        
        var kubernetesCloud = new KubernetesCloud("cifarm-kubernetes");
        kubernetesCloud.setNamespace("jenkins");
        kubernetesCloud.setSkipTlsVerify(true);
        kubernetesCloud.setJenkinsUrl("http://jenkins.jenkins.svc.cluster.local");
        kubernetesCloud.setWebSocket(true);
        jenkins.clouds.add(kubernetesCloud);
        jenkins.save();
    }
}
