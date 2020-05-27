; based on Damien's answer here: https://superuser.com/a/1358752
#NoEnv ; recommended for performance and compatibility with future autohotkey releases.
#UseHook
#InstallKeybdHook
#SingleInstance force

;; deactivate capslock completely
SetCapslockState, AlwaysOff

; Remap ` to escape
`:: Send {Esc}

; CapsLock + tilde will behave normally
CapsLock & `::`

; Vim key navigation
CapsLock & h:: Send {Blind}{Left}
CapsLock & j:: Send {Blind}{Down}
CapsLock & k:: Send {Blind}{Up}
CapsLock & l:: Send {Blind}{Right}

; F keys
CapsLock & 1::f1
CapsLock & 2::f2
CapsLock & 3::f3
CapsLock & 4::f4
CapsLock & 5::f5
CapsLock & 6::f6
CapsLock & 7::f7
CapsLock & 8::f8
CapsLock & 9::f9
CapsLock & 0::f10
CapsLock & -::f11
CapsLock & =::f12

; Volume controls
CapsLock & _::SoundSet, -5
CapsLock & +::SoundSet, +5