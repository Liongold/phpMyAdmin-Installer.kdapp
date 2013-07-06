class MainView extends JView
  constructor:->
    super
    @header = new KDHeaderView
      type:"big"
      title:"phpMyAdmin Installer"
    @installer = new KDSelectBox
      type: "select"
      name: "version"
      defaultValue: "4.0.4.1"
      selectOptions: [
                      { title:"4.0.4.1 (Recommended)", value:"4.0.4.1" }
                      { title: "3.5.8.1", value:"3.5.8.1" }
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
      callback:=>
        input = KDFormView.findChildInputs @
        version = input[0].getValue()
        language = input[1].getValue()
        command = KD.getSingleton "kiteController"
        command.run "cd ~/Web/ && wget http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/#{version}/phpMyAdmin-#{version}-#{language}.zip && unzip phpMyAdmin-#{version}-#{language}.zip && mv phpMyAdmin-#{version}-#{language} phpmyadmin && rm -f phpMyAdmin-#{version}-#{language}.zip && cd phpmyadmin && mkdir config && mv config.sample.inc.php config.inc.php", (err, response)=>
          if err
            new KDNotificationView
              title: "There was an error installing phpMyAdmin. Please try again. "
          else
            new KDNotificationView
              title: "Successfully Installed!"
  pistachio:->
    """
    {{> @header}}
    <br><br>
    {{> @installer}}
    <br><br>
    {{> @language_selector}}
    <br><br>
    {{> @install_button}}
    """
  appView.addSubView new MainView
    cssClass: "app"
