/**
 * 
 */
package edu.ncsu.csc216.flix_2.ui;

import java.awt.BorderLayout;
import java.awt.CardLayout;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.GridLayout;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JComboBox;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSeparator;
import javax.swing.JTextField;
import javax.swing.ListSelectionModel;
import javax.swing.SwingConstants;
import javax.swing.UIManager;


import edu.ncsu.csc216.flix_2.customer.CustomerAccountManager;
import edu.ncsu.csc216.flix_2.customer.MovieCustomerAccountSystem;
import edu.ncsu.csc216.flix_2.rental_system.DVDRentalSystem;
import edu.ncsu.csc216.flix_2.rental_system.RentalManager;

/**
 * Creates the Graphic User Interface for the user to interact with
 * @author Will
 *
 */
public class MovieSystemGUI extends JFrame implements ActionListener {

	/**
	 * Default ID generated by Eclipse
	 */
	private static final long serialVersionUID = 1L;

	private static RentalManager rentals;
	
	private CustomerAccountManager accountManager;
	
	/** Title for top of GUI. */
	private static final String APP_TITLE = "DVD Rental System";
	
	private JButton browse;
	private JButton browseBrowse;
	private JButton browseQueue;
	
    private JButton show;
    private JButton showBrowse;
    private JButton showQueue;
    
    private JButton logout;
    private JButton logoutBrowse;
    private JButton logoutQueue;
    
    private JButton login;
    private JButton addCustomer;
    private JButton cancel;
    private JButton quit;
    
    
    private JTextField usernameField;
    private JTextField passwordField;
    
    private JButton returnMovie;
    private JButton moveMovieUp;
    private JButton removeMovie;
    private JButton reserveMovie;
    
    private JPanel cardLogin;
    private JPanel cardBrowse;
    private JPanel cardQueue;
    
    
    private JPanel cardHolder;
    
    private static final String USERNAME = "                                       Username:";
    private static final String PASSWORD = "                                       Password:";
    private JLabel username;
    private JLabel password;
    
    private JList<String> list;
    private DefaultListModel<String> listModel;
    
    private JList<String> listHome;
    private DefaultListModel<String> listModelHome;
    
    private JList<String> listReserve;
    private DefaultListModel<String> listModelReserve;
	
	
	/**
	 * Constructs a MovieSystemGUI
	 * @param name Title of the application
	 */
	public MovieSystemGUI(String name) {
		super(name);
		setResizable(true);
		accountManager = new MovieCustomerAccountSystem(rentals);

	}
	
	
	/**
     * Create the GUI and show it.
     */
    private static void createAndShowGUI() {
        //Create and set up the window.
        MovieSystemGUI frame = new MovieSystemGUI(APP_TITLE);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        //Set up the content pane.
        frame.addComponentsToPane(frame.getContentPane(), frame);
        //Display the window.
        //frame.pack();
        frame.setSize(500, 400);
        frame.setLocation(350, 120);
        frame.setVisible(true);
    }
     
    private void addComponentsToPane(Container pane, final JFrame frame) {
		// TODO Auto-generated method stub
    	
		browse = new JButton("Browse");
		browse.setEnabled(false);
		show = new JButton("Show My Queue");
		show.setEnabled(false);
		logout = new JButton("Logout");
		logout.setEnabled(false);
		
		browseBrowse = new JButton("Browse");
		showBrowse = new JButton("Show My Queue");
		logoutBrowse = new JButton("Logout");
		
		browseQueue = new JButton("Browse");
		showQueue = new JButton("Show My Queue");
		logoutQueue = new JButton("Logout");
				
		username = new JLabel(USERNAME);
		usernameField = new JTextField();
		password = new JLabel(PASSWORD);
		passwordField = new JTextField();
		
		login = new JButton("Login");
		
		addCustomer = new JButton("Add New Customer");
		addCustomer.setEnabled(false);
		cancel = new JButton("Cancel Account");
		cancel.setEnabled(false);
		quit = new JButton("Quit");
		quit.setEnabled(false);
		
		reserveMovie = new JButton("Reserve Selected Movie");
		returnMovie = new JButton("Return Selected Movie");
		moveMovieUp = new JButton("Move Selected Movie Up");
		removeMovie = new JButton("Remove Selected Movie");
		
		
		//JButton test = new JButton("TEST");
		
		returnMovie = new JButton("Return Selected Movie");
		
		cardLogin = new JPanel(new GridLayout(4, 1));
		JPanel cardLogin2 = new JPanel();
		JPanel cardLogin3 = new JPanel(new GridLayout(2, 2));
		JPanel cardLogin4 = new JPanel();
		JPanel cardLogin5 = new JPanel();
		
		
		//browse.setEnabled(false);
		cardLogin2.add(browse, BorderLayout.LINE_START);
		cardLogin2.add(show, BorderLayout.NORTH);
		cardLogin2.add(logout, BorderLayout.LINE_END);
		cardLogin.add(cardLogin2, BorderLayout.NORTH);
		cardLogin3.add(username);
		cardLogin3.add(usernameField);
		cardLogin3.add(password);
		cardLogin3.add(passwordField);
		cardLogin.add(cardLogin3, BorderLayout.CENTER);
		cardLogin4.add(login, BorderLayout.CENTER);
		cardLogin.add(cardLogin4);
		cardLogin5.add(addCustomer, BorderLayout.LINE_START);
		cardLogin5.add(cancel, BorderLayout.NORTH);
		cardLogin5.add(quit, BorderLayout.LINE_END);
		cardLogin.add(cardLogin5);
		
		
		cardQueue = new JPanel(new GridLayout(5, 1));
		//cardQueue.setPreferredSize(new Dimension(500, 500));
		final JPanel cardQueue2 = new JPanel();
		final JPanel cardQueue3 = new JPanel();
		final JPanel cardQueue4 = new JPanel();
		final JPanel cardQueue5 = new JPanel();
		final JPanel cardQueue6 = new JPanel();
		
		
		
		cardQueue2.add(browseQueue, BorderLayout.LINE_START);
		cardQueue2.add(showQueue, BorderLayout.NORTH);
		cardQueue2.add(logoutQueue, BorderLayout.LINE_END);
		
		cardQueue4.add(returnMovie);
		
		cardQueue6.add(moveMovieUp, BorderLayout.LINE_START);
		cardQueue6.add(removeMovie, BorderLayout.LINE_END);
		
		
		
		cardBrowse = new JPanel(new GridLayout(3, 1));
		JPanel cardBrowse2 = new JPanel();
		JPanel cardBrowse3 = new JPanel();
		JPanel cardBrowse4 = new JPanel();
		
		
		
		
		listModel = new DefaultListModel<String>();
		String movies[] = rentals.showInventory().split("\\r?\\n");
		for(int i = 0; i < movies.length; i++){
			listModel.addElement(movies[i]);
		}
		
		
		list = new JList<String>(listModel);
		list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		list.setSelectedIndex(0);
		list.setVisibleRowCount(5);
		JScrollPane listScrollPane = new JScrollPane(list);
		listScrollPane.setBorder(BorderFactory.createTitledBorder("Movie inventory"));
		
		
		cardBrowse2.add(browseBrowse, BorderLayout.LINE_START);
		cardBrowse2.add(showBrowse, BorderLayout.NORTH);
		cardBrowse2.add(logoutBrowse, BorderLayout.LINE_END);
		cardBrowse.add(cardBrowse2, BorderLayout.NORTH);
		
		cardBrowse3.setLayout(new BoxLayout(cardBrowse3, BoxLayout.LINE_AXIS));
		cardBrowse3.add(Box.createHorizontalStrut(10));
		cardBrowse3.add(new JSeparator(SwingConstants.VERTICAL));
		cardBrowse3.add(Box.createHorizontalStrut(10));
		//cardBrowse3.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
		//cardBrowse3.setPreferredSize(new Dimension(300,500));
		cardBrowse.add(listScrollPane, BorderLayout.CENTER);
		cardBrowse.add(cardBrowse3, BorderLayout.CENTER);
		//cardBrowse.add(cardBrowse4, BorderLayout.CENTER);
		
		cardBrowse4.add(reserveMovie, BorderLayout.SOUTH);
		cardBrowse.add(cardBrowse4, BorderLayout.SOUTH);
		
		
		
		
		
		
		
		
		
		cardHolder = new JPanel(new CardLayout());
		cardHolder.add(cardLogin, "Card 1");
		cardHolder.add(cardQueue, "Card 2");
		cardHolder.add(cardBrowse, "Card 3");
				
		pane.add(cardHolder, BorderLayout.PAGE_START);
		//pane.add(cardQueue, BorderLayout.CENTER);
		
		show.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	CardLayout cardLayout = (CardLayout) cardHolder.getLayout();
            	cardLayout.show(cardHolder, "Card 2");
            	
            	if (0 == cardQueue.getComponentCount()){
            	listModelHome = new DefaultListModel<String>();
        		String moviesAtHome[] = rentals.traverseAtHomeQueue().split("\\r?\\n");
        		for(int i = 0; i < moviesAtHome.length; i++){
        			listModelHome.addElement(moviesAtHome[i]);
        		}
        		
        		listHome = new JList<String>(listModelHome);
        		listHome.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        		listHome.setSelectedIndex(0);
        		listHome.setVisibleRowCount(5);
        		JScrollPane listScrollPaneHome = new JScrollPane(listHome);
        		listScrollPaneHome.setBorder(BorderFactory.createTitledBorder("Movies at Home"));
        		cardQueue3.setLayout(new BoxLayout(cardQueue3, BoxLayout.LINE_AXIS));
        		cardQueue3.add(Box.createHorizontalStrut(10));
        		cardQueue3.add(new JSeparator(SwingConstants.VERTICAL));
        		cardQueue3.add(Box.createHorizontalStrut(10));
        		
        		//second list
        		listModelReserve = new DefaultListModel<String>();
        		String moviesReserved[] = rentals.traverseReserveQueue().split("\\r?\\n");
        		for(int i = 0; i < moviesReserved.length; i++){
        			listModelReserve.addElement(moviesReserved[i]);
        		}
        		
        		listReserve = new JList<String>(listModelReserve);
        		listReserve.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        		listReserve.setSelectedIndex(0);
        		listReserve.setVisibleRowCount(5);
        		JScrollPane listScrollPaneReserved = new JScrollPane(listReserve);
        		listScrollPaneReserved.setBorder(BorderFactory.createTitledBorder("My Queue"));
        		
        		cardQueue5.setLayout(new BoxLayout(cardQueue5, BoxLayout.LINE_AXIS));
        		cardQueue5.add(Box.createHorizontalStrut(10));
        		cardQueue5.add(new JSeparator(SwingConstants.VERTICAL));
        		cardQueue5.add(Box.createHorizontalStrut(10));
        		
        		
        		
        		cardQueue.add(cardQueue2, BorderLayout.NORTH);
        		cardQueue.add(listScrollPaneHome, BorderLayout.CENTER);
        		cardQueue.add(cardQueue3, BorderLayout.CENTER);
        		cardQueue.add(cardQueue4);
        		cardQueue.add(cardQueue5, BorderLayout.NORTH);
        		cardQueue.add(listScrollPaneReserved, BorderLayout.CENTER);
        		cardQueue.add(cardQueue6, BorderLayout.SOUTH);
            	}
            	
            	
            }
        });
		
		showBrowse.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	CardLayout cardLayout = (CardLayout) cardHolder.getLayout();
            	cardLayout.show(cardHolder, "Card 2");
            	
            	if (0 == cardQueue.getComponentCount()){
            	listModelHome = new DefaultListModel<String>();
        		String moviesAtHome[] = rentals.traverseAtHomeQueue().split("\\r?\\n");
        		for(int i = 0; i < moviesAtHome.length; i++){
        			listModelHome.addElement(moviesAtHome[i]);
        		}
        		
        		listHome = new JList<String>(listModelHome);
        		listHome.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        		listHome.setSelectedIndex(0);
        		listHome.setVisibleRowCount(5);
        		JScrollPane listScrollPaneHome = new JScrollPane(listHome);
        		listScrollPaneHome.setBorder(BorderFactory.createTitledBorder("Movies at Home"));
        		
        		cardQueue3.setLayout(new BoxLayout(cardQueue3, BoxLayout.LINE_AXIS));
        		cardQueue3.add(Box.createHorizontalStrut(10));
        		cardQueue3.add(new JSeparator(SwingConstants.VERTICAL));
        		cardQueue3.add(Box.createHorizontalStrut(10));
        		
        		
        		//second list
        		listModelReserve = new DefaultListModel<String>();
        		String moviesReserved[] = rentals.traverseReserveQueue().split("\\r?\\n");
        		for(int i = 0; i < moviesReserved.length; i++){
        			listModelReserve.addElement(moviesReserved[i]);
        		}
        		
        		listReserve = new JList<String>(listModelReserve);
        		listReserve.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        		listReserve.setSelectedIndex(0);
        		listReserve.setVisibleRowCount(5);
        		JScrollPane listScrollPaneReserved = new JScrollPane(listReserve);
        		listScrollPaneReserved.setBorder(BorderFactory.createTitledBorder("My Queue"));
        		
        		cardQueue5.setLayout(new BoxLayout(cardQueue5, BoxLayout.LINE_AXIS));
        		cardQueue5.add(Box.createHorizontalStrut(10));
        		cardQueue5.add(new JSeparator(SwingConstants.VERTICAL));
        		cardQueue5.add(Box.createHorizontalStrut(10));
        		
        		
        		
        		cardQueue.add(cardQueue2, BorderLayout.NORTH);
        		cardQueue.add(listScrollPaneHome, BorderLayout.CENTER);
        		cardQueue.add(cardQueue3, BorderLayout.CENTER);
        		cardQueue.add(cardQueue4);
        		cardQueue.add(cardQueue5, BorderLayout.NORTH);
        		cardQueue.add(listScrollPaneReserved, BorderLayout.CENTER);
        		cardQueue.add(cardQueue6, BorderLayout.SOUTH);
            } else {
            	String moviesAtHome[] = rentals.traverseAtHomeQueue().split("\\r?\\n");
        		for(int i = 0; i < moviesAtHome.length; i++){
        			
        			listModelHome.addElement(moviesAtHome[i]);
        			
        		}
        		
        		String moviesReserved[] = rentals.traverseReserveQueue().split("\\r?\\n");
        		for(int i = 0; i < moviesReserved.length; i++){
        			
        			listModelReserve.addElement(moviesReserved[i]);
        			
        		}
            }
            }
        });
		
		login.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	try {
            	accountManager.login(usernameField.getText(), passwordField.getText());
            	} catch (IllegalArgumentException e1){
            		JOptionPane.showMessageDialog(frame, e1.getMessage());
            	}
            	//usernameField.setText("");
            	if(accountManager.isAdminLoggedIn()){
            		login.setEnabled(false);
            		addCustomer.setEnabled(true);
            		cancel.setEnabled(true);
            		quit.setEnabled(true);
            		logout.setEnabled(true);
            	} else if(accountManager.isCustomerLoggedIn()){
            		login.setEnabled(false);
            		browse.setEnabled(true);
            		show.setEnabled(true);
            		logout.setEnabled(true);
            	}
            }
        });
		
		logout.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	accountManager.logout();
            	usernameField.setText("");
            	passwordField.setText("");
            	browse.setEnabled(false);
            	show.setEnabled(false);
            	logout.setEnabled(false);
            	addCustomer.setEnabled(false);
            	cancel.setEnabled(false);
            	quit.setEnabled(false);
            	login.setEnabled(true);
            }
        });
		
		logoutBrowse.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	CardLayout cardLayout = (CardLayout) cardHolder.getLayout();
            	cardLayout.show(cardHolder, "Card 1");
            	accountManager.logout();
            	usernameField.setText("");
            	passwordField.setText("");
            	browse.setEnabled(false);
            	show.setEnabled(false);
            	logout.setEnabled(false);
            	addCustomer.setEnabled(false);
            	cancel.setEnabled(false);
            	quit.setEnabled(false);
            	login.setEnabled(true);
            }
        });
		
		logoutQueue.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	CardLayout cardLayout = (CardLayout) cardHolder.getLayout();
            	cardLayout.show(cardHolder, "Card 1");
            	accountManager.logout();
            	usernameField.setText("");
            	passwordField.setText("");
            	browse.setEnabled(false);
            	show.setEnabled(false);
            	logout.setEnabled(false);
            	addCustomer.setEnabled(false);
            	cancel.setEnabled(false);
            	quit.setEnabled(false);
            	login.setEnabled(true);
            }
        });
		
		reserveMovie.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	int movieIndex = list.getSelectedIndex();
            	rentals.addToCustomerQueue(movieIndex);
            	System.out.println(rentals.traverseAtHomeQueue() + "X");
            	System.out.println(rentals.traverseReserveQueue());
            }
        });
		
		returnMovie.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	rentals.returnItemToInventory(listHome.getSelectedIndex());
            	listModelHome.remove(listHome.getSelectedIndex());
            	
            	String moviesAtHome[] = rentals.traverseAtHomeQueue().split("\\r?\\n");
        		for(int i = 0; i < moviesAtHome.length; i++){
        			
        			listModelHome.addElement(moviesAtHome[i]);
        			
        		}
        		
        		listModelReserve.clear();
        		String moviesReserved[] = rentals.traverseReserveQueue().split("\\r?\\n");
        		for(int i = 0; i < moviesReserved.length; i++){
        			
        			listModelReserve.addElement(moviesReserved[i]);
        			
        		}
            }
        });
		
		moveMovieUp.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	rentals.reserveMoveAheadOne(listReserve.getSelectedIndex());
            	listModelReserve.clear();
        		String moviesReserved[] = rentals.traverseReserveQueue().split("\\r?\\n");
        		for(int i = 0; i < moviesReserved.length; i++){
        			
        			listModelReserve.addElement(moviesReserved[i]);
        			
        		}
            }
        });
		
		removeMovie.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	rentals.removeSelectedFromReserves(listReserve.getSelectedIndex());
            	listModelReserve.clear();
        		String moviesReserved[] = rentals.traverseReserveQueue().split("\\r?\\n");
        		for(int i = 0; i < moviesReserved.length; i++){
        			
        			listModelReserve.addElement(moviesReserved[i]);
        			
        		}
            }
        });
		quit.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	System.exit(0);
            }
        });
		
		cancel.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	String title = "Enter the username for the account to be cancelled";
            	//JOptionPane.getFrameForComponent(frame).setSize(new Dimension(100,100));
            	String input = JOptionPane.showInputDialog(null, "Username:" , title , JOptionPane.WARNING_MESSAGE);
            	
            	try {
            	accountManager.cancelAccount(input);
            	} catch (IllegalArgumentException e1){
            		JOptionPane.showMessageDialog(frame, "No matching customer account found.");
            	} 
            }
        });
		
		browse.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
            	CardLayout cardLayout = (CardLayout) cardHolder.getLayout();
            	cardLayout.show(cardHolder, "Card 3");
                
            }
        });
		
		browseQueue.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
            	CardLayout cardLayout = (CardLayout) cardHolder.getLayout();
            	cardLayout.show(cardHolder, "Card 3");
                
            }
        });
		
		addCustomer.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e){
                //System.out.println();
            	//JOptionPane.showMessageDialog(frame, "HYPE");
            	String title = "Enter the new customer's username and password";
            	JPanel panelHolder = new JPanel();
            	JPanel boxPanel = new JPanel();
            	JPanel panel = new JPanel(new GridLayout(2, 2));
            	
            	String limitOptions[] = {"1" , "2" , "3" , "4" , "5"};
            	
				
				@SuppressWarnings({ "rawtypes", "unchecked" })
				JComboBox limit = new JComboBox(limitOptions);
				//limit.addActionListener(this);
            	boxPanel.add(limit);
            	
            	panel.add(new JLabel("Username:"));
            	JTextField usernameSpace = new JTextField();
            	usernameSpace.setPreferredSize(new Dimension(120, 20));
            	panel.add(usernameSpace);
            	
            	panel.add(new JLabel("Password:"));
            	JTextField passwordSpace = new JTextField();
            	panel.add(passwordSpace);
            	
            	panelHolder.add(panel);
            	panelHolder.add(boxPanel);
            	
            	//Object[] options = {"Cancel", "OK"};
            	//Dimension size = panelHolder.getPreferredSize();
            	panelHolder.setPreferredSize(new Dimension(300, 50));
        
            	JOptionPane.showConfirmDialog(frame, panelHolder, title,
            												JOptionPane.OK_CANCEL_OPTION,
            												JOptionPane.QUESTION_MESSAGE
            												);
            	int movieLimit = Integer.parseInt((String) limit.getSelectedItem());
            	
            	//Customer c = new Customer(username.getText(), password.getText(), movieLimit);
            	try {
            	accountManager.addNewCustomer(usernameSpace.getText(), passwordSpace.getText(), movieLimit);
            	} catch (IllegalStateException e1){
            		JOptionPane.showMessageDialog(frame, "There is no room for additional customers.");
            	} catch (IllegalArgumentException e1){
            		if(usernameSpace.getText().contains(" ") || passwordSpace.getText().contains(" ")
            				|| usernameSpace.getText().equals("") || passwordSpace.getText().equals("")){
            		JOptionPane.showMessageDialog(frame, "Username and password must have non-whitespace characters.");
            		} else {
            			JOptionPane.showMessageDialog(frame, "Customer already has an account.");
            		}
            	}
            	
            }
        });
		
		
	}

    /**
     * Main method of GUI
     * @param args Command line arguments user can enter
     */
	public static void main(String[] args) {
		rentals = new DVDRentalSystem(args[0]);
        /* Turn off metal's use of bold fonts */
        UIManager.put("swing.boldMetal", Boolean.FALSE);
 
        createAndShowGUI();
         
    }
	@Override
	public void actionPerformed(ActionEvent action) {
		// TODO Auto-generated method stub
		}

}
