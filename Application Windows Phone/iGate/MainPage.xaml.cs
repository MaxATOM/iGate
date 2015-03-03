using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;
using iGate.Resources;


namespace iGate
{


public partial class MainPage : PhoneApplicationPage
{

    private  SocketClient client = new SocketClient();
    private string result;

    public MainPage()
        {
            InitializeComponent();
        }


    private void btnEcho_Click(object sender, RoutedEventArgs e)
{
    ClearLog();

    int portEcho = Convert.ToInt32(txtInput.Text);

    // Make sure we can perform this action with valid data
    if (ValidateRemoteHost() && ValidateInput())
    {
        // Instantiate the SocketClient
        
        // Attempt to connect to the echo server
        Log(String.Format("Connecting to server '{0}' over port {1}", txtRemoteHost.Text, portEcho), true);
        result = client.Connect(txtRemoteHost.Text, portEcho);
        Log(result, false);

    }

}

    private void btnDeco_Click(object sender, RoutedEventArgs e)
{
    // Clear the log 
    ClearLog();
    if (ValidateRemoteHost() && ValidateInput())
    {
      
        client.Close();
    }

}

    private void btnOuvrir_Click(object sender, RoutedEventArgs e)
{

    if (ValidateRemoteHost() && ValidateInput())
    {
      
        Log(String.Format("Sending forward to server ..."), true);
        result = client.Send("forward");
        Log(result, false);

        // Receive a response from the echo server
        //Log("Requesting Receive ...", true);
        //result = client.Receive();
        //Log(result, false);

      
    }

}

    private void btnFermer_Click(object sender, RoutedEventArgs e)
{
  
    if (ValidateRemoteHost() && ValidateInput())
    {
      
        Log(String.Format("Sending reverse to server ..."), true);
        result = client.Send("reverse");
        Log(result, false);

        // Receive a response from the echo server
        //Log("Requesting Receive ...", true);
        //result = client.Receive();
        //Log(result, false);

      
    }

}


#region UI Validation
/// <summary>
/// Validates the txtInput TextBox
/// </summary>
/// <returns>True if the txtInput TextBox contains valid data, otherwise 
/// False.
///</returns>
private bool ValidateInput()
{
    // txtInput must contain some text
    if (String.IsNullOrWhiteSpace(txtInput.Text))
    {
        MessageBox.Show("Please enter some text to echo");
         return false;
     }

    return true;
}

/// <summary>
/// Validates the txtRemoteHost TextBox
/// </summary>
/// <returns>True if the txtRemoteHost contains valid data,
/// otherwise False
/// </returns>
private bool ValidateRemoteHost()
{
    // The txtRemoteHost must contain some text
    if (String.IsNullOrWhiteSpace(txtRemoteHost.Text))
    {
        MessageBox.Show("Please enter a host name");
        return false;
    }

    return true;
}
#endregion

#region Logging
/// <summary>
/// Log text to the txtOutput TextBox
/// </summary>
/// <param name="message">The message to write to the txtOutput TextBox</param>
/// <param name="isOutgoing">True if the message is an outgoing (client to server)
/// message, False otherwise.
/// </param>
/// <remarks>We differentiate between a message from the client and server 
/// by prepending each line  with ">>" and "<<" respectively.</remarks>
private void Log(string message, bool isOutgoing)
{
    string direction = (isOutgoing) ? ">> " : "<< ";
    txtOutput.Text += Environment.NewLine + direction + message;
}

/// <summary>
/// Clears the txtOutput TextBox
/// </summary>
private void ClearLog()
{
    txtOutput.Text = String.Empty;
}
#endregion
    }

}