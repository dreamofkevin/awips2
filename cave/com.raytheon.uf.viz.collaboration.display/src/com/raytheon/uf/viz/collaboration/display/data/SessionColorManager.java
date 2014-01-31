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
package com.raytheon.uf.viz.collaboration.display.data;

import java.util.HashMap;
import java.util.Map;

import org.eclipse.swt.graphics.RGB;

import com.raytheon.uf.viz.collaboration.comm.provider.user.VenueParticipant;
import com.raytheon.viz.core.ColorUtil;

/**
 * 
 * Manages colors of different users for a session
 * 
 * <pre>
 * 
 * SOFTWARE HISTORY
 * 
 * Date         Ticket#    Engineer    Description
 * ------------ ---------- ----------- --------------------------
 * Apr 3, 2012            mnash     Initial creation
 * Jan 30, 2014 2698       bclement    changed UserId to VenueParticipant
 * 
 * </pre>
 * 
 * @author mnash
 * @version 1.0
 */

public class SessionColorManager {

    private Map<VenueParticipant, RGB> colors;

    private static RGB[] rgbPresets = null;

    /**
     * 
     */
    public SessionColorManager() {
        if (colors == null) {
            colors = new HashMap<VenueParticipant, RGB>();
            rgbPresets = ColorUtil.getResourceColorPresets();
        }
    }

    /**
     * @return the colors
     */
    public Map<VenueParticipant, RGB> getColors() {
        return colors;
    }

    public void setColors(Map<VenueParticipant, RGB> map) {
        colors = map;
    }

    public RGB getColorFromUser(VenueParticipant user) {
        if (colors.get(user) == null) {
            addUser(user);
        }
        return colors.get(user);
    }

    public void setColorForUser(VenueParticipant id, RGB rgb) {
        colors.put(id, rgb);
    }

    /**
     * Add a user with a new color value
     * 
     * @param user
     */
    public void addUser(VenueParticipant user) {
        int count = colors.size();
        if (rgbPresets.length <= count) {
            count = count % rgbPresets.length;
        }
        colors.put(user, rgbPresets[count]);
    }

    public void clearColors() {
        colors.clear();
    }
}
