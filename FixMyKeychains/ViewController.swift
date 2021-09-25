import Cocoa

class ViewController: NSViewController
{
    //Change name of the window and prevent user from resizing window.
    override func viewDidAppear()
    {
        self.view.window?.title = "FixMyKeychains"
        view.window!.styleMask.remove(.resizable)
    }
    
    //What clicking Fix My Keychains actually does.
    @IBAction func fixMyKeychains(_ sender: NSButton)
    {
        //Shell script to move all Keychains to ~/KeychainsBackup - The wildcard use in Bash is amazing, in Swift, it is not. We are using Swift to AppleScript to Shell Script FYI.
        let moveScript = NSAppleScript(source: "do shell script \"mkdir -p ~/Library/KeychainsBackup/$(date +%Y%m%d%H%M) && mv ~/Library/Keychains/* ~/Library/KeychainsBackup/$(date +%Y%m%d%H%M)/\"")!
        var moveErrorDict : NSDictionary?
            moveScript.executeAndReturnError(&moveErrorDict)
        if  moveErrorDict != nil { print(moveErrorDict!) }
        
        //Inform user that their Keychains have been fixed (moved) and that they will be logged out.
        func dialogOKCancel(question: String, text: String) -> Bool
        {
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = text
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Log Out")
            return alert.runModal() == .alertFirstButtonReturn
        }
        _ = dialogOKCancel(question: "SAVE ALL FILES!", text: "All applications will be closed after clicking \"Log Out\".")
        
        //Log out command.
        let logOutScript = NSAppleScript(source: "tell application \"System Events\" to log out")!
        var logOutErrorDict : NSDictionary?
            logOutScript.executeAndReturnError(&logOutErrorDict)
        if  logOutErrorDict != nil { print(logOutErrorDict!) }
    //Quit the app
    exit(0)
    }
}
