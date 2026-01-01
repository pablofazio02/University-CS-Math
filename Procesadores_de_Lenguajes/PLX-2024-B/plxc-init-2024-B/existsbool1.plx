boolean p,q;
if (exists p, p || (!q && !p) ) {
    print(1);
}
if (exists p, p && (!q && p) ) {
    print(2);
}
print(0);
