using Test
using Qt5QuickControls_jll
using QML

# absolute path in case working dir is overridden
qml_data = QByteArray("""
import QtQuick 2.0
import QtQuick.Controls 1.0

ApplicationWindow {
  title: "My Application"
  width: 100
  height: 100
  visible: true

  Rectangle {
    width: 100; height: 100; color: "red"

    Text {
      anchors.centerIn: parent
      text: hi // Context property set from Julia
    }

    Timer {
      interval: 500; running: true; repeat: false
      onTriggered: Qt.quit()
    }
  }
}
""")

qengine = init_qmlengine()
ctx = root_context(qengine)
set_context_property(ctx, "hi", "Hi from Julia")

qcomp = QQmlComponent(qengine)
set_data(qcomp, qml_data, QML.QUrl())
create(qcomp, qmlcontext());

exec()
