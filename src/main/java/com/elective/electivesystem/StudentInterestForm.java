package com.elective.electivesystem;

import javax.swing.*;
import java.awt.*;
import com.mongodb.client.*;
import org.bson.Document;

public class StudentInterestForm extends JFrame {

    JTextField nameField, studentIdField;
    JCheckBox dsa, web, ai, cp;
    JComboBox<String> platformBox, frequencyBox, goalBox;
    JButton submitBtn;

    public StudentInterestForm() {

        setTitle("Student Coding Profile");
        setSize(650, 500);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        JPanel main = new JPanel(new BorderLayout());

        // HEADER
        JLabel title = new JLabel("Coding Profile Form", JLabel.CENTER);
        title.setFont(new Font("Segoe UI", Font.BOLD, 22));
        title.setOpaque(true);
        title.setBackground(new Color(30, 41, 59));
        title.setForeground(Color.WHITE);
        title.setPreferredSize(new Dimension(100, 60));

        main.add(title, BorderLayout.NORTH);

        // FORM PANEL
        JPanel form = new JPanel(new GridBagLayout());
        form.setBorder(BorderFactory.createEmptyBorder(20, 40, 20, 40));
        form.setBackground(Color.WHITE);

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(10, 10, 10, 10);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        // FIELDS
        nameField = new JTextField();
        studentIdField = new JTextField();

        dsa = new JCheckBox("DSA");
        web = new JCheckBox("Web Development");
        ai = new JCheckBox("AI/ML");
        cp = new JCheckBox("Competitive Programming");

        platformBox = new JComboBox<>(new String[]{"LeetCode", "Codeforces", "HackerRank"});
        frequencyBox = new JComboBox<>(new String[]{"Daily", "Weekly", "Rarely"});
        goalBox = new JComboBox<>(new String[]{"Placement", "Competitive Programming", "Projects"});

        submitBtn = new JButton("Save Profile");
        submitBtn.setBackground(new Color(79, 70, 229));
        submitBtn.setForeground(Color.WHITE);

        int y = 0;

        // NAME
        gbc.gridx = 0; gbc.gridy = y;
        form.add(new JLabel("Name:"), gbc);

        gbc.gridx = 1;
        form.add(nameField, gbc);

        y++;

        // STUDENT ID
        gbc.gridx = 0; gbc.gridy = y;
        form.add(new JLabel("Student ID:"), gbc);

        gbc.gridx = 1;
        form.add(studentIdField, gbc);

        y++;

        // INTEREST LABEL
        gbc.gridx = 0; gbc.gridy = y;
        gbc.gridwidth = 2;
        form.add(new JLabel("Select Interests:"), gbc);

        y++;

        // INTEREST PANEL (CENTERED BOX)
        JPanel interestPanel = new JPanel(new GridLayout(2, 2, 15, 10));
        interestPanel.setBorder(BorderFactory.createLineBorder(Color.LIGHT_GRAY));
        interestPanel.setBackground(Color.WHITE);

        interestPanel.add(dsa);
        interestPanel.add(web);
        interestPanel.add(ai);
        interestPanel.add(cp);

        gbc.gridy = y;
        form.add(interestPanel, gbc);

        y++;
        gbc.gridwidth = 1;

        // PLATFORM
        gbc.gridx = 0; gbc.gridy = y;
        form.add(new JLabel("Preferred Platform:"), gbc);

        gbc.gridx = 1;
        form.add(platformBox, gbc);

        y++;

        // FREQUENCY
        gbc.gridx = 0; gbc.gridy = y;
        form.add(new JLabel("Coding Frequency:"), gbc);

        gbc.gridx = 1;
        form.add(frequencyBox, gbc);

        y++;

        // GOAL
        gbc.gridx = 0; gbc.gridy = y;
        form.add(new JLabel("Goal:"), gbc);

        gbc.gridx = 1;
        form.add(goalBox, gbc);

        y++;

        // BUTTON CENTER
        gbc.gridx = 0;
        gbc.gridy = y;
        gbc.gridwidth = 2;
        submitBtn.setPreferredSize(new Dimension(200, 35));
        form.add(submitBtn, gbc);

        main.add(form, BorderLayout.CENTER);
        add(main);

        submitBtn.addActionListener(e -> saveData());

        setVisible(true);
    }

    private void saveData() {
        try {
             String mongoUri=System.getenv("MONGO_URI");
           MongoClient client =MongoClients.create(mongoUri);
            MongoDatabase db = client.getDatabase("electiveDB");
            MongoCollection<Document> col = db.getCollection("codingProfiles");

            String interests = "";
            if (dsa.isSelected()) interests += "DSA ";
            if (web.isSelected()) interests += "Web ";
            if (ai.isSelected()) interests += "AI ";
            if (cp.isSelected()) interests += "CP ";

            Document doc = new Document("name", nameField.getText())
                    .append("studentId", studentIdField.getText())
                    .append("interests", interests.trim())
                    .append("platform", platformBox.getSelectedItem())
                    .append("frequency", frequencyBox.getSelectedItem())
                    .append("goal", goalBox.getSelectedItem());

            col.insertOne(doc);

            JOptionPane.showMessageDialog(this, "Saved Successfully ✅");

            client.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        new StudentInterestForm();
    }
}