import org.jetbrains.kotlin.gradle.dsl.KotlinVersion
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")

    // Kotlin 2.2 a supprimé le support de languageVersion 1.6. Certains
    // plugins Flutter (sentry_flutter ≤ 8.13.x, etc.) déclarent encore 1.6
    // pour compat descendante → compileDebugKotlin échoue.
    // Force un plancher 1.8 (accepté par Kotlin 2.2) sur TOUS les
    // sous-projets, plugins inclus. À retirer quand l'écosystème aura
    // rattrapé Kotlin 2.2.
    tasks.withType<KotlinCompile>().configureEach {
        compilerOptions {
            languageVersion.set(KotlinVersion.KOTLIN_1_8)
            apiVersion.set(KotlinVersion.KOTLIN_1_8)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
