import xml.etree.ElementTree as ET
import tempfile
import unittest
from pathlib import Path

from src.java.isolation_validation.clean_evosuite_tests import (
    remove_evosuite_runtime_dependency,
)


class CleanEvosuiteTests(unittest.TestCase):
    def test_remove_runtime_dependency_preserves_other_dependencies(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            project_path = Path(temp_dir)
            pom = project_path / "pom.xml"
            pom.write_text(
                """<project xmlns="http://maven.apache.org/POM/4.0.0">
  <dependencies>
    <dependency>
      <groupId>org.evosuite</groupId>
      <artifactId>evosuite-standalone-runtime</artifactId>
      <version>1.2.0</version>
    </dependency>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.13.2</version>
    </dependency>
  </dependencies>
</project>
""",
                encoding="utf-8",
            )

            self.assertTrue(remove_evosuite_runtime_dependency(project_path))

            namespace = {"m": "http://maven.apache.org/POM/4.0.0"}
            root = ET.parse(pom).getroot()
            dependencies = {
                (
                    dependency.findtext("m:groupId", namespaces=namespace),
                    dependency.findtext("m:artifactId", namespaces=namespace),
                )
                for dependency in root.findall(".//m:dependency", namespace)
            }
            self.assertNotIn(
                ("org.evosuite", "evosuite-standalone-runtime"), dependencies
            )
            self.assertIn(("junit", "junit"), dependencies)
            self.assertFalse(remove_evosuite_runtime_dependency(project_path))


if __name__ == "__main__":
    unittest.main()
