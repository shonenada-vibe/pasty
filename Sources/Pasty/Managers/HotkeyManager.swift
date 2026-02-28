import Carbon.HIToolbox
import AppKit

@MainActor
private var hotkeyManagerInstance: HotkeyManager?

private func hotkeyEventHandler(
    _: EventHandlerCallRef?,
    _: EventRef?,
    _: UnsafeMutableRawPointer?
) -> OSStatus {
    DispatchQueue.main.async { @MainActor in
        hotkeyManagerInstance?.onHotkeyPressed?()
    }
    return noErr
}

@MainActor
final class HotkeyManager {
    static let shared = HotkeyManager()

    var onHotkeyPressed: (() -> Void)?

    private var hotkeyRef: EventHotKeyRef?
    private var eventHandlerRef: EventHandlerRef?

    private init() {
        hotkeyManagerInstance = self
    }

    func register() {
        guard SettingsManager.shared.hotkeyEnabled else { return }
        guard hotkeyRef == nil else { return }

        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )

        InstallEventHandler(
            GetEventDispatcherTarget(),
            hotkeyEventHandler,
            1,
            &eventType,
            nil,
            &eventHandlerRef
        )

        let hotkeyID = EventHotKeyID(
            signature: OSType(0x50535459), // "PSTY"
            id: 1
        )

        RegisterEventHotKey(
            UInt32(kVK_ANSI_V),
            UInt32(cmdKey | shiftKey),
            hotkeyID,
            GetEventDispatcherTarget(),
            0,
            &hotkeyRef
        )
    }

    func unregister() {
        if let ref = hotkeyRef {
            UnregisterEventHotKey(ref)
            hotkeyRef = nil
        }
        if let handler = eventHandlerRef {
            RemoveEventHandler(handler)
            eventHandlerRef = nil
        }
    }
}
