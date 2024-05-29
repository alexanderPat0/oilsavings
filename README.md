# oilsavings

A new Flutter project.


WebScrapping en flutter  --> https://www.geeksforgeeks.org/web-scraping-in-flutter/
Página de la que webscrappear --> https://www.dieselogasolina.com/
Página del gobierno con precios anuales de los carburantes --> https://www.miteco.gob.es/es/buscador.html?fulltext=precios+carburantes&offset=0&search=true
Mapa con los precios de los diferentes carburantes --> https://geoportalgasolineras.es/geoportal-instalaciones/Inicio
Listado de todas las gasolineras de españa -->  https://www.aeescam.com/eess
Usar de MindCare el diaryScreen para mostrar tarjetitas de las diferentes gasolineras --> https://github.com/SamuraiJuanjo/Trabajo-PMDM-Grupo5/blob/main/lib/screens/user/diary_screen.dart


IDEA:
QUIZÁS LO MEJOR NO ES HACER UN MAPA, SI NO MOSTRAR TARJETITAS DE LAS GASOLINERAS CERCANAS CON INFORMACICIÓN SOBRE ELLAS.
PARA IMPLEMENTAR ALGO DE DIFICULTAD, AÑADIR UN BOTÓN SOBRE LAS TARJETAS QUE LE


https://firebase.flutter.dev/docs/auth/password-auth
https://console.firebase.google.com/u/0/project/oilsavings/authentication/providers?hl=es-419


https://stackoverflow.com/questions/66549206/some-input-files-use-or-override-a-deprecated-api-flutter ARCHIVOS DEPRECATED
https://stackoverflow.com/questions/68889827/how-to-sync-firestore-database-and-firebase-authentication CONECTAR USUARIO AUTH CON FIREBASE



//get firebase user
FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();

//get reference
DatabaseReference ref = FirebaseDatabase.getInstance().getReference(USERS_TABLE);

//build child
ref.child(user.getUid()).setValue(user_class);

USERS_TABLE is a direct child of root.

Then when you want to retrieve the data, get a reference to the user by its UID, listen for addListenerForSingleValueEvent() (invoked only once), and iterate over the result with reflection:

//get firebase user
FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();

//get reference
DatabaseReference ref = FirebaseDatabase.getInstance().getReference(USERS_TABLE).child(user.getUid());
//IMPORTANT: .getReference(user.getUid()) will not work although user.getUid() is unique. You need a full path!

//grab info
ref.addListenerForSingleValueEvent(new ValueEventListener() {
    @Override
    public void onDataChange(DataSnapshot dataSnapshot) {
        final Profile tempProfile = new Profile(); //this is my user_class Class
        final Field[] fields = tempProfile.getClass().getDeclaredFields();
        for(Field field : fields){
            Log.i(TAG, field.getName() + ": " + dataSnapshot.child(field.getName()).getValue());
        }
    }

    public void onCancelled(DatabaseError databaseError) {
    }
});
edit:

Or without reflection:

@Override
public void onDataChange(DataSnapshot dataSnapshot) {
    final Profile p = dataSnapshot.getValue(Profile.class);
}