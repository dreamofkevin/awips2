/**
* This software was developed and / or modified by Raytheon Company,
* pursuant to Contract DG133W-05-CQ-1067 with the US Government.
* 
* U.S. EXPORT CONTROLLED TECHNICAL DATA
* This software product contains export-restricted data whose
* export/transfer/disclosure is restricted by U.S. law. Dissemination
* to non-U.S. persons whether in the United States or abroad requires
* an export license or other authorization.
* 
* Contractor Name:        Raytheon Company
* Contractor Address:     6825 Pine Street, Suite 340
*                         Mail Stop B8
*                         Omaha, NE 68106
*                         402.291.0100
* 
* See the AWIPS II Master Rights File ("Master Rights File.pdf") for
* further licensing information.
**/
package com.raytheon.uf.common.dataplugin.shef.tables;
// default package
// Generated Oct 17, 2008 2:22:17 PM by Hibernate Tools 3.2.2.GA

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * Shefprob generated by hbm2java
 * 
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Oct 17, 2008                        Initial generation by hbm2java
 * Aug 19, 2011      10672     jkorman Move refactor to new project
 * Oct 07, 2013       2361     njensen Removed XML annotations
 * 
 * </pre>
 * 
 * @author jkorman
 * @version 1.1
 */
@Entity
@Table(name = "shefprob")
@com.raytheon.uf.common.serialization.annotations.DynamicSerialize
public class Shefprob extends com.raytheon.uf.common.dataplugin.persist.PersistableDataObject implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String probcode;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private Float probability;

    @com.raytheon.uf.common.serialization.annotations.DynamicSerializeElement
    private String name;

    public Shefprob() {
    }

    public Shefprob(String probcode) {
        this.probcode = probcode;
    }

    public Shefprob(String probcode, Float probability, String name) {
        this.probcode = probcode;
        this.probability = probability;
        this.name = name;
    }

    @Id
    @Column(name = "probcode", unique = true, nullable = false, length = 1)
    public String getProbcode() {
        return this.probcode;
    }

    public void setProbcode(String probcode) {
        this.probcode = probcode;
    }

    @Column(name = "probability", precision = 8, scale = 8)
    public Float getProbability() {
        return this.probability;
    }

    public void setProbability(Float probability) {
        this.probability = probability;
    }

    @Column(name = "name", length = 20)
    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }

}
