package atom.com.igate;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.os.AsyncTask;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;


public class iGate extends ActionBarActivity {

    private TCPClient mTcpClient = null;
    private connectTask conctTask = null;
    private String IPADRESS = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_i_gate);
        // Initialisation des variables locales
        Button connectButton = (Button)findViewById(R.id.connectButton);
        Button ouvrirPortail = (Button)findViewById(R.id.boutonOuvrir);
        Button fermerPortail = (Button)findViewById(R.id.boutonFermer);
        final EditText editText = (EditText)findViewById(R.id.adresseField);

        // Fonction lorsqu'on appuie sur le bouton Se connecter
        connectButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                IPADRESS = editText.getText().toString();
                mTcpClient = null;
                conctTask = new connectTask();
                conctTask.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR);



            }
        });

        // Fonction lorsqu'on appuie sur le bouton Ouvrir portail
        ouvrirPortail.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mTcpClient != null) mTcpClient.sendMessage("open");

            }
        });

        // Fonction lorsqu'on appuie sur le bouton Fermer portail
        fermerPortail.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mTcpClient != null) mTcpClient.sendMessage("close");

            }
        });
    }


    public class connectTask extends AsyncTask<String,String,TCPClient> {
        @Override
        protected TCPClient doInBackground(String... message)
        {
            //we create a TCPClient object and
            mTcpClient = new TCPClient(new TCPClient.OnMessageReceived()
            {
                @Override
                //here the messageReceived method is implemented
                public void messageReceived(String message)
                {
                    try
                    {
                        //this method calls the onProgressUpdate
                        publishProgress(message);
                        if(message!=null) System.out.println("Return Message from Socket::::: >>>>> "+message);
                    }
                    catch (Exception e)
                    {
                        e.printStackTrace();
                    }
                }
            });
            mTcpClient.run(IPADRESS);
            if(mTcpClient!=null) mTcpClient.sendMessage("Initial Message when connected with Socket Server");

            return null;
        }

        @Override
        protected void onProgressUpdate(String... values) {
            super.onProgressUpdate(values);

            // notify the adapter that the data set has changed. This means that new message received
            // from server was added to the list
        }
    }

    @Override
    protected void onDestroy()
    {
        try
        {
            System.out.println("onDestroy.");
            mTcpClient.sendMessage("bye");
            mTcpClient.stopClient();
            conctTask.cancel(true);
            conctTask = null;
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        super.onDestroy();

    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_i_gate, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) return true;

        return super.onOptionsItemSelected(item);
    }
}
