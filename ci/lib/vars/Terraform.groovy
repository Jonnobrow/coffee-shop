#!/usr/bin/env groovy
/**
 * Terraform Pipeline Library
 *
 * @param Map params
 *
 * Usage:
 *
 * @Library('jonnobrow') _
 *
 * node ('main') {
 *    Terraform()
 * }
 *
 */
def call(Map params = [:]) {

    def defaultParams = [
        binary: "/usr/bin/terraform",
        pluginDir: "",
        initUpgrade: false,
        targets: [],
        extraArgs: [],
        command: "",
        vars: []
    ]

    final Map finalParams = defaultParams << params

    def baseCommands = [
        apply: "apply",
        destroy: "apply -destroy",
        init: "init ${finalParams.initUpgrade ? "-upgrade" : ""}".trim(),
    ]

    def terraform = finalParams.binary
    def command = baseCommands.get(finalParams.command, baseCommands.init)

    Map parallelExecutions = [:]

    finalParams.targets.each{target ->
        parallelExecutions["${target}"] = {
            stage("${finalParams.command} ${target}") {
                sh """${terraform} ${command} ${varsf(finalParams.vars)} ${extraArgs.join('')}""".trim()
            }
        }
    }
}

def varsf(vars) {
    vars.collect{var,val ->
        "-var=\"${var}=${val}\""
    }.join(' ')
}
