class InstallerView extends JView
  constructor:->
    super
    @header = new KDHeaderView
      type:"big"
      title:"phpMyAdmin Installer"
    @installer = new KDSelectBox
      type: "select"
      name: "version"
      defaultValue: "4.0.10"
      selectOptions: [
                      { title:"4.0.10 (Recommended)", value:"4.0.10" }
                      { title: "3.5.8.2", value:"3.5.8.2" }
                    ]
    @language_selector = new KDSelectBox
        type: "select"
        name: "language"
        defaultValue: "english"
        selectOptions: [
                        { title: "English", value: "english" }
                        { title: "All Languages", value: "all-languages" }
                    ]
    @install_button = new KDButtonView
      title:"Install phpMyAdmin"
      style: "cupid-green"
      loader:
          color: "#FFFFFF"
          diameter: 15
      callback:=>
        input = KDFormView.findChildInputs @
        version = input[0].getValue()
        language = input[1].getValue()
        command = KD.getSingleton "kiteController"
        new KDNotificationView
            title: "Downloading phpMyAdmin #{version}..."
            type: "mini"
            duration: 15000
        command.run "cd ~/Web/ && wget http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/#{version}/phpMyAdmin-#{version}-#{language}.zip", (err, response)=>
            if err
                new KDNotificationView
                    title: "There was an error downloading phpMyAdmin. Please try again in a few minutes. "
                    type: "mini"
                    duration: 5000
                    cssClass: "error"
                @install_button.hideLoader()
            else
                new KDNotificationView
                    title: "Installing phpMyAdmin #{version}..."
                    type: "mini"
                    duration: 5000
                command.run "cd ~/Web/ && unzip phpMyAdmin-#{version}-#{language}.zip && mv phpMyAdmin-#{version}-#{language} phpmyadmin && rm -f phpMyAdmin-#{version}-#{language}.zip && cd phpmyadmin && mkdir config && mv config.sample.inc.php config.inc.php", (err, response)=>
                    if err
                        new KDNotificationView
                            title: "There was an error installing phpMyAdmin. Please try again later. "
                            type: "mini"
                            duration: 5000
                            cssClass: "error"
                        @install_button.hideLoader()
                    else
                        new KDNotificationView
                            title: "Successfully Installed!"
                            cssClass: "success"
                            type: "mini"
                            duration: 5000
                            @install_button.hideLoader()
                            appView.destroySubViews()
                            appView.addSubView new PanelView
  pistachio:->
    """
    {{> @header}}
    <br><br>
    {{> @installer}}
    <br><br>
    {{> @language_selector}}
    <br><br>
    {{> @install_button}}
    <br><br>
    <p>Currently, there are 2 supported versions of phpMyAdmin. The latest one is the 4.0+ branch which is recommended for all users and is update regularly. The other version is the 3.5.8+ branch which can be used without the use of Javascript since it uses HTML frames. This branch only gets security updates and does not receive other updates. </p>
    <br><br>
    <p>After you complete the installation, you can log into phpMyAdmin with your MySQL credentials. Username is <strong>root</strong> and password is the one you choose when you installed MySQL. If you have created any other MySQL users, you can login as them as well. </p>
    <br><br>
    <p>This Koding application is licensed under the MIT License. You should have received a copy of this license together with this application. </p>
    """
#
class PanelView extends JView
  constructor:->
    super
    @header = new KDHeaderView
      type: "big"
      title: "phpMyAdmin Installer"
     @subheader = new KDHeaderView
        type: "small"
        title: "You already have phpMyAdmin Installed!"
    @run_button = new KDButtonView
      title: "Run"
      style: "cupid-green"
      callback:=>
        {nickname} = KD.whoami().profile
        window.open("https://#{nickname}.kd.io/phpmyadmin")
    @update_button = new KDButtonView
      title: "Update"
      style: "update_button"
      callback:=>
        new KDNotificationView
          title: "Coming Soon..."
    @delete_button = new KDButtonView
      title: "Delete"
      style: "clean-red"
      loader:
          color: "#FFFFFF"
          diameter: 15
      callback:=>
        new KDNotificationView
            title: "Deleting phpMyAdmin..."
            type: "mini"
            duration: 5000
        command = KD.getSingleton "kiteController"
        command.run "cd ~/Web/ && rm -r phpmyadmin", (err, reponse) =>
            if err
                new KDNotificationView
                    title: "There was an error deleting phpMyAdmin. Please try again. "
                    type: "mini"
                    cssClass: "error"
                    duration: 5000
            else
                new KDNotificationView
                    title: "Successfully Deleted"
                    cssClass: "success"
                    type: "mini"
                    duration: 5000
                appView.destroySubViews()
                appView.addSubView new InstallerView
  pistachio:->
    """
    {{> @header}}
    {{> @subheader}}
    <br><br>
    <div class='frame50 pma'>
        <p>&nbsp;</p>
    </div>
    <div class='frame50'>
        {{> @run_button}}
        <br><br>
        {{> @update_button}}
        <br><br>
        {{> @delete_button}}
    </div>
    <p>&nbsp;</p>
    <div class='frame100'>
        <p>This Koding application is licensed under the MIT License. You should have received the license together with this application. The phpMyAdmin logo is licensed under the <a href='http://creativecommons.org/licenses/by-sa/3.0/' target='_blank'>Creative Commons Attribution-Share Alike 3.0 Unported</a>.</p>
    </div>
    """
# 
command = KD.getSingleton "kiteController"
command.run "ls Web/phpmyadmin", (err, response) =>
    if err
        appView.addSubView new InstallerView
            cssClass: "installer"
    else
        appView.addSubView new PanelView
            cssClass: "panel"
