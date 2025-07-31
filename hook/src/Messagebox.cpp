#include "Messagebox.h"
#include <windows.h>

void ShowMessageBox(const char* message, const char* title, UINT icon)
{
    MessageBoxA(NULL, message, title, icon);
}