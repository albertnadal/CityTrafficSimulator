With Tipus; use Tipus;
package body QueueArray is

   protected body Queue is
    -- Avança la posició de l'iterador  
    procedure Increment( X: in out Integer) is
    begin
        if X = Q_Array'Last then
            X := Q_Array'First;
        else
            X := X + 1;
        end if;
    end Increment;

   -- Esborra un item de la cua
    procedure Dequeue( X: out Item; EnEspera: out Integer) is
    begin
        if Is_Empty then
            raise Underflow;
        end if;

        Q_Size := Q_Size-1;
        EnEspera:=Q_Size;
        X := Q_Array( Q_Front );
        Increment( Q_Front );
    end Dequeue;

    -- Afegeix un item al final de cua
    procedure Enqueue( X: Item) is
    begin
        if Is_Full then
           raise Overflow;
        else
           begin
              Q_Size := Q_Size + 1;
              Increment( Q_Rear );
              Q_Array( Q_Rear ) := X;
           end;
        end if;
    end Enqueue;

    -- Indica si la cua esta buïda o no
    function Is_Empty return Boolean is
    begin
        return Q_Size = 0;
    end Is_Empty;

    -- Indica si la cua esta plena
    function Is_Full return Boolean is
    begin
        return Q_Size = Q_Array'Length;
    end Is_Full;

    -- Inicialitza la cua
    procedure Make_Empty is
    begin
        Q_Front := Q_Array'First;
        Q_Rear  := Q_Array'First - 1; 
        Q_Size  := 0;
    end Make_Empty;
           
    end Queue;


 procedure Enqueue ( X: Item; Q: in out pqueue) is
 begin
    Q.Enqueue(X);
 end Enqueue;
 
 procedure Dequeue (X: out Item; Buit: out Boolean; EnEspera: out Integer; Q: in out pqueue) is
 begin
    Buit := Q.Is_Empty;
    if not Buit then
       begin
          Q.Dequeue(X, EnEspera);
       end;
    end if;
 end Dequeue;
 
 function Is_Empty (Q: pqueue) return Boolean is
 begin
    return Q.Is_Empty;
 end Is_Empty;
 
 function Is_Full (Q: pqueue) return Boolean is
 begin
    return Q.Is_Full;
 end Is_Full;
 
 procedure Make_Empty (Q: in out pqueue) is
 begin
   Q.Make_Empty;
 end Make_Empty;
   
end QueueArray;	
