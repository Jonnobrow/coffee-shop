def environments = ["dev", "test", "stage", "prod"]

def ciJobsFolderName = "ci"

folder("${ciJobsFolderName}") {
    displayName "Continuous Integration Jobs"
}

environments.each {env ->
    def pipelineJobName = "${ciJobsFolderName}/${env}"

    pipelineJob("${pipelineJobName}") {
        definition {
            cps {
                script("""
                @Library('jonnobrow') _

                node {
                    Terraform([command: 'init', targets: ['${env}']])
                }
                """.stripIndent())
            }
        }
    }
}
