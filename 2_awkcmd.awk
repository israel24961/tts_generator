BEGIN   { 
    FS="<p>";#Separator of fields
    RS="</p>";#Separator of entries (text passed), usually new line
}
!/^$/{ #Ignores empty lines
    regex="^<";
    if (length($2) > 0  ){
        print  $2;
    }
}

END     {}
