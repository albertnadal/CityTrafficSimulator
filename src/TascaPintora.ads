with PaquetGrafic; use PaquetGrafic;
with QueueArray; use QueueArray;

package TascaPintora is

   task type Pintor(D: Pdibuixant; Q: Pqueue);
   type PPintor is access Pintor; 

end TascaPintora;
